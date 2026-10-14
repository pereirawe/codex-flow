#!/usr/bin/env python3
"""Behavioral migration tests on isolated files, no API/model calls."""
import importlib.util
import json
from pathlib import Path
import shutil
import sqlite3
import subprocess
import tempfile
import unittest

SCRIPT=Path(__file__).resolve().parents[1]/'flowctl.py'
spec=importlib.util.spec_from_file_location('flowctl',SCRIPT)
flow=importlib.util.module_from_spec(spec);spec.loader.exec_module(flow)

class FlowTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.addCleanup(self.tmp.cleanup)
        self.base=Path(self.tmp.name);self.original_root=flow.ROOT
        # Copy only reusable runtime/catalog files, never private source data.
        flow.ROOT=self.base/'flow';flow.ROOT.mkdir()
        for d in ['catalog','config','scripts','command-skills','codex-agents','skills']:
            shutil.copytree(self.original_root/d,flow.ROOT/d,ignore=shutil.ignore_patterns('__pycache__'))
        self.addCleanup(setattr,flow,'ROOT',self.original_root)

    def test_install_preserves_existing_settings_and_is_idempotent(self):
        home=self.base/'home';(home/'.codex').mkdir(parents=True)
        settings='model = "user-selected-model"\n'
        (home/'.codex/config.toml').write_text(settings)
        (home/'.codex/AGENTS.md').write_text('Existing personal instructions.\n')
        flow.global_install(home);flow.global_install(home)
        self.assertEqual((home/'.codex/config.toml').read_text(),settings)
        content=(home/'.codex/AGENTS.md').read_text()
        self.assertIn('Existing personal instructions.',content)
        self.assertEqual(content.count(flow.BEGIN),1)
        self.assertTrue((home/'.agents/skills/develop').is_symlink())
        self.assertTrue((home/'.codex/agents/cf_development_discovery.toml').is_symlink())

    def test_project_preserves_issues_rules_extensions_and_repeated_init(self):
        project=self.base/'project';legacy=project/'.opencode';legacy.mkdir(parents=True)
        issues='## Known Issues\n\n### 42. Existing issue\n- Status: ready\n- Remote: #8\n'
        (legacy/'known_issues.md').write_text(issues)
        (legacy/'resolved_issues.md').write_text('Preserve the archive.\n')
        (project/'AGENTS.md').write_text('Business rule: phone only.\nAPI provider https://opencode.ai/zen/v1\nSee .opencode/known_issues.md\n')
        (legacy/'locale').write_text('es\n')
        skill=legacy/'skills/custom';skill.mkdir(parents=True)
        (skill/'SKILL.md').write_text('---\nname: custom\ndescription: Project custom function\n---\n\nPerform the project function.\n')
        (project/'opencode.jsonc').write_text('''{
          // Context and inline roles
          "instructions": ["docs/business.md"],
          "agent": {"qa": {"description": "Project QA", "prompt": "Honor the phone-only rule."}},
          "command": {"ocf:report": {"description": "Project report", "template": "Generate report."}},
        }''')
        flow.migrate_project(project);flow.migrate_project(project)
        self.assertEqual((project/'.codex/known_issues.md').read_text(),issues)
        self.assertEqual((legacy/'known_issues.md').read_text(),issues)
        self.assertEqual((project/'.codex/locale').read_text(),'es\n')
        self.assertEqual((project/'.codex/resolved_issues.md').read_text(),'Preserve the archive.\n')
        content=(project/'AGENTS.md').read_text()
        self.assertIn('Business rule: phone only.',content)
        self.assertIn('https://opencode.ai/zen/v1',content)
        self.assertEqual(content.count(flow.BEGIN),1)
        self.assertIn('docs/business.md',(project/'.codex/AGENTS.md').read_text())
        self.assertTrue((project/'.agents/skills/project-project-custom').is_symlink())
        self.assertTrue((project/'.codex/agents/project_project_qa.toml').exists())
        self.assertTrue((project/'.agents/skills/project-project-report').is_symlink())
        self.assertNotIn('<!',(project/'.codex/.gitignore').read_text())
        self.assertEqual((project/'.codex/.gitignore').read_text().count('# codex-flow:begin'),1)
        self.assertNotIn(str(project),(project/'.agents/skills/project-project-custom/SKILL.md').read_text())
        moved=self.base/'moved-project'
        shutil.copytree(project,moved,symlinks=True)
        self.assertTrue((moved/'.agents/skills/project-project-custom/SKILL.md').is_file())

    def test_project_existing_codex_issue_is_not_overwritten(self):
        project=self.base/'project';(project/'.opencode').mkdir(parents=True);(project/'.codex').mkdir()
        (project/'.opencode/known_issues.md').write_text('Legacy tracker')
        (project/'.codex/known_issues.md').write_text('New Codex tracker')
        flow.migrate_project(project)
        self.assertEqual((project/'.codex/known_issues.md').read_text(),'New Codex tracker')

    def test_vendor_adapter_reads_clone_and_unregistration_cleans_owned_link(self):
        vendor=flow.ROOT/'vendor/example/skill';vendor.mkdir(parents=True)
        (vendor/'SKILL.md').write_text('---\nname: custom\ndescription: Test skill\n---\n\nOriginal upstream instructions.\n')
        home=self.base/'home'
        self.assertEqual(flow.vendor_register(home),1)
        link=home/'.agents/skills/vendor-example-custom';self.assertTrue(link.is_symlink())
        self.assertIn(str(vendor/'SKILL.md'),(link/'SKILL.md').read_text())
        shutil.rmtree(vendor.parent)
        self.assertEqual(flow.vendor_register(home),0);self.assertFalse(link.is_symlink())

    def test_history_exports_messages_without_credential_tables(self):
        database=self.base/'history.db';c=sqlite3.connect(database)
        c.executescript('''CREATE TABLE session_v2(id TEXT,directory TEXT,title TEXT,parent_id TEXT,time_created INT,time_updated INT);
          CREATE TABLE session_message(id TEXT,session_id TEXT,type TEXT,seq INT,time_created INT,data TEXT);
          CREATE TABLE credential(value TEXT);''')
        c.execute('INSERT INTO session_v2 VALUES(?,?,?,?,?,?)',('ses_one','/project','Old decision',None,1,2))
        c.execute('INSERT INTO session_message VALUES(?,?,?,?,?,?)',('msg_one','ses_one','user',1,1,json.dumps({'text':'Keep phone-only authentication.'})))
        c.execute('INSERT INTO credential VALUES(?)',('private-account-value',));c.commit();c.close()
        folder=self.base/'export';flow.export_history(database,folder)
        files=list(folder.rglob('*'));texts=''.join(x.read_text() for x in files if x.is_file())
        self.assertIn('Keep phone-only authentication.',texts)
        self.assertNotIn('private-account-value',texts)
        self.assertEqual(len(json.loads((folder/'index.json').read_text())),1)

    def test_runtime_uses_codex_and_preserves_argument_boundaries(self):
        stub=self.base/'codex';output=self.base/'argv.json'
        stub.write_text('#!/usr/bin/env python3\nimport json,os,sys\nopen(os.environ["ARGV_FILE"],"w").write(json.dumps(sys.argv[1:]))\n');stub.chmod(0o755)
        import os
        env=dict(os.environ,CODEX_BIN=str(stub),ARGV_FILE=str(output))
        result=subprocess.run(['bash',str(flow.ROOT/'scripts/codex-run.sh'),str(self.base),'discovery','idea with spaces and $()'],env=env,capture_output=True,text=True)
        self.assertEqual(result.returncode,0,result.stderr)
        args=json.loads(output.read_text());self.assertEqual(args[0],'exec')
        self.assertIn(str(self.base),args)
        self.assertIn('idea with spaces and $()',args[-1])
        self.assertNotIn('--dangerously-bypass-approvals-and-sandbox',args)

    def test_project_dry_run_performs_no_writes(self):
        project=self.base/'project';project.mkdir()
        flow.migrate_project(project,dry_run=True)
        self.assertEqual(list(project.iterdir()),[])

    def test_install_checkout_already_at_flow_location(self):
        home=self.base/'home';destination=home/'.codex/flow'
        destination.parent.mkdir(parents=True)
        shutil.move(flow.ROOT,destination);flow.ROOT=destination
        flow.global_install(home)
        self.assertTrue((destination/'scripts/flowctl.py').is_file())
        self.assertTrue((home/'.agents/skills/develop').is_symlink())

if __name__=='__main__':unittest.main()
