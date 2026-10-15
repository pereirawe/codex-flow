#!/usr/bin/env python3
"""Offline regressions for the three critical lifecycle findings."""
import os, pathlib, subprocess, tempfile, unittest
ROOT = pathlib.Path(__file__).resolve().parents[2]
class CriticalLifecycle(unittest.TestCase):
 def setUp(self):
  self.tmp=tempfile.TemporaryDirectory(); self.addCleanup(self.tmp.cleanup)
  self.p=pathlib.Path(self.tmp.name); self.ctx=self.p/'.codex'; self.ctx.mkdir()
  subprocess.run(['git','init','-q',str(self.p)],check=True)
  subprocess.run(['git','remote','add','origin','git@github.com:owner/repo.git'],cwd=self.p,check=True)
  self.bin=self.p/'bin'; self.bin.mkdir()
  for name in ('gh','glab'):
   f=self.bin/name; f.write_text('#!/bin/sh\ncase "$*" in\n *"pr view"*) [ "$STATE" != ERROR ] || exit 1; echo "$STATE";;\n *"mr view"*) printf \'{"state":"%s"}\\n\' "$STATE";;\n *"issue view"*) echo CLOSED;;\n *) echo "mutation" >> "$CALL_LOG";;\nesac\n');f.chmod(0o755)
  self.env=dict(os.environ,PATH=str(self.bin)+':'+os.environ['PATH'],STATE='OPEN',CALL_LOG=str(self.p/'calls'))
 def entry(self,i=1,status='ready',pr='-'):
  return f'### {i}. Regression\n- Status: {status}\n- Type: bug\n- Severity: high\n- Priority: high\n- Report: tests\n- Base branch: main\n- Reviewers: 1 (security)\n- Remote: #1\n- PR: {pr}\n- Location: scripts\n- Description: Regression\n- Impact: Data safety\n- Business rules: -\n- Acceptance criteria: Safe\n- Tests: Scenario one\n  Scenario two\n  Scenario three\n- Suggested fix: -\n'
 def write(self,text): (self.ctx/'known_issues.md').write_text(text)
 def run_script(self,name,*args):return subprocess.run(['bash',str(ROOT/'scripts'/name),*args],cwd=self.p,env=self.env,text=True,capture_output=True)
 def test_lint_both_orders(self):
  self.write(self.entry())
  for args in [('1','--strict'),('--strict','1')]:self.assertEqual(self.run_script('issue-lint.sh',*args).returncode,0)
 def test_lint_invalid_arguments(self):
  self.write(self.entry())
  for args in [('--unknown','1'),('1','2'),('--strict',)]:self.assertNotEqual(self.run_script('issue-lint.sh',*args).returncode,0)
 def test_close_rejects_unproven_merge_without_mutation(self):
  for provider in ['github.com','gitlab.com']:
   subprocess.run(['git','remote','set-url','origin',f'git@{provider}:owner/repo.git'],cwd=self.p,check=True)
   for state in ['OPEN','UNKNOWN','ERROR']:
    self.env['STATE']=state
    for pr in ['#7','-']:
     original=self.entry(status='in-publish',pr=pr);self.write(original)
     r=self.run_script('close_issue.sh','1');self.assertNotEqual(r.returncode,0,r.stdout)
     self.assertEqual((self.ctx/'known_issues.md').read_text(),original)
     self.assertFalse((self.ctx/'resolved_issues.md').exists());self.assertFalse((self.p/'calls').exists())
 def test_close_merged_archives(self):
  self.write(self.entry(status='in-publish',pr='#7'));self.env['STATE']='MERGED'
  r=self.run_script('close_issue.sh','1');self.assertEqual(r.returncode,0,r.stderr)
  self.assertNotIn('### 1.',(self.ctx/'known_issues.md').read_text());self.assertIn('### 1.',(self.ctx/'resolved_issues.md').read_text())
 def test_gitlab_merged_archives(self):
  subprocess.run(['git','remote','set-url','origin','git@gitlab.com:owner/repo.git'],cwd=self.p,check=True)
  self.write(self.entry(status='in-publish',pr='#7'));self.env['STATE']='merged'
  r=self.run_script('close_issue.sh','1');self.assertEqual(r.returncode,0,r.stderr)
  self.assertIn('### 1.',(self.ctx/'resolved_issues.md').read_text())
 def test_remote_close_failure_preserves_issue(self):
  f=self.bin/'gh';f.write_text('#!/bin/sh\ncase "$*" in\n *"pr view"*) echo MERGED;;\n *"issue view"*) echo OPEN;;\n *) exit 1;;\nesac\n')
  original=self.entry(status='in-publish',pr='#7');self.write(original)
  self.assertNotEqual(self.run_script('close_issue.sh','1').returncode,0)
  self.assertEqual((self.ctx/'known_issues.md').read_text(),original)
  self.assertFalse((self.ctx/'resolved_issues.md').exists())
 def append(self,*args):return self.run_script('append-issue.sh','--title','New','--type','chore',*args)
 def test_id_max_active_and_archive(self):
  self.write(self.entry(9)+self.entry(1));(self.ctx/'resolved_issues.md').write_text('### 12. Archived\n')
  r=self.append();self.assertEqual(r.returncode,0,r.stderr);self.assertIn('### 13.',(self.ctx/'known_issues.md').read_text())
 def test_duplicate_ids_rejected(self):
  original=self.entry();self.write(original);(self.ctx/'resolved_issues.md').write_text('### 5. Archived\n')
  for i in ['1','5','0','-1']:
   self.assertNotEqual(self.append('--id',i).returncode,0);self.assertEqual((self.ctx/'known_issues.md').read_text(),original)
 def test_failed_lint_rolls_back(self):
  original=self.entry();self.write(original)
  r=self.append('--type','feat');self.assertNotEqual(r.returncode,0);self.assertEqual((self.ctx/'known_issues.md').read_text(),original)
 def test_concurrent_allocation_unique(self):
  self.write(self.entry())
  jobs=[subprocess.Popen(['bash',str(ROOT/'scripts/append-issue.sh'),'--title','New','--type','chore'],cwd=self.p,env=self.env,stdout=subprocess.PIPE,stderr=subprocess.PIPE) for _ in range(8)]
  for p in jobs:p.communicate();self.assertEqual(p.returncode,0)
  import re
  ids=re.findall(r'^### (\d+)\.',(self.ctx/'known_issues.md').read_text(),re.M)
  self.assertEqual(len(ids),9);self.assertEqual(len(set(ids)),9)
if __name__=='__main__':unittest.main()
