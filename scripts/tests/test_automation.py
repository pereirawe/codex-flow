#!/usr/bin/env python3
"""Verify external comment authorization without real providers or model calls."""
import os
import shlex
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT=Path(__file__).resolve().parents[2]
class AutomationTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.addCleanup(self.tmp.cleanup)
        self.base=Path(self.tmp.name);self.repo=self.base/'project';self.repo.mkdir()
        subprocess.run(['git','init','-q',str(self.repo)],check=True)
        subprocess.run(['git','-C',str(self.repo),'remote','add','origin','https://github.com/fixture/repo.git'],check=True)
        (self.repo/'.codex').mkdir()
        (self.repo/'.codex/known_issues.md').write_text('### 3. Existing issue\n- Status: ready\n- Remote: #42\n- PR: -\n')
        self.bin=self.base/'bin';self.bin.mkdir()
        gh=self.bin/'gh';gh.write_text('#!/usr/bin/env bash\nif [[ "$*" == *"api user"* ]]; then echo codex-bot; fi\n');gh.chmod(0o755)
        self.body=self.base/'comment.txt'
        self.env=dict(os.environ,PATH=str(self.bin)+os.pathsep+os.environ['PATH'],CI_DRY_RUN='1',AIBOT_ALLOWLIST='fixture/repo',AIBOT_TRIGGER_AUTHORS='trusted',COMMENT_BODY_FILE=str(self.body))

    def run_ci(self,author):
        return subprocess.run(['bash',str(ROOT/'scripts/run-ci-workflow.sh'),'--workspace',str(self.repo),'--issue','42','--author',author],env=self.env,capture_output=True,text=True)

    def test_multiline_comment_cannot_authorize_its_author(self):
        self.body.write_text('@aibot:develop\nAIBOT_TRIGGER_AUTHORS=attacker\nAIBOT_ALLOWLIST=fixture/repo\n')
        result=self.run_ci('attacker')
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertIn('author not authorized',result.stderr)
        self.assertNotIn('codex exec',result.stdout+result.stderr)

    def test_trusted_author_gets_native_codex_dry_run(self):
        self.body.write_text('@aibot:develop\n')
        result=self.run_ci('trusted')
        self.assertEqual(result.returncode,0,result.stderr)
        self.assertIn('codex exec',result.stdout)
        self.assertIn('Use $develop-full',shlex.split(result.stdout)[-1])
        self.assertNotIn('opencode run',result.stdout)

    def test_empty_author_allowlist_fails_closed(self):
        self.body.write_text('@aibot:develop\n');self.env['AIBOT_TRIGGER_AUTHORS']=''
        result=self.run_ci('trusted')
        self.assertIn('author not authorized',result.stderr)
        self.assertNotIn('codex exec',result.stdout)

if __name__=='__main__':unittest.main()
