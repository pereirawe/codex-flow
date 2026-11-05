const fs=require('fs');
const path=require('path');
const {chromium}=require('playwright');
(async()=>{
 const source=path.resolve(process.argv[2]); const base=path.dirname(source); const manifest=JSON.parse(fs.readFileSync(source,'utf8'));
 const mermaidAsset=process.argv[3]; if(!mermaidAsset) throw Error('Informe o asset Mermaid local validado');
 const browser=await chromium.launch({executablePath:process.env.CHROME_PATH||'/usr/bin/google-chrome',headless:true,args:['--no-sandbox','--disable-dev-shm-usage']});
 const page=await browser.newPage({viewport:{width:1300,height:1200},deviceScaleFactor:2});
 await page.setContent('<html><head><style>body{margin:0;padding:16px;background:white}svg{display:block;max-width:none}*{animation:none!important}</style></head><body><main id="diagram"></main></body></html>');
 await page.addScriptTag({path:path.resolve(mermaidAsset)});
 await page.evaluate(()=>mermaid.initialize({startOnLoad:false,securityLevel:'strict',theme:'base',themeVariables:{fontFamily:'Arial',fontSize:'18px',primaryColor:'#e4f2ef',primaryTextColor:'#173f44',primaryBorderColor:'#659d98',secondaryColor:'#b6dbd5',tertiaryColor:'#f1f7f6',lineColor:'#507a7b',critBkgColor:'#258d87',critBorderColor:'#176267',critTextColor:'#ffffff',pie1:'#176267',pie2:'#49a49d',pie3:'#add6ce'},flowchart:{htmlLabels:false,useMaxWidth:false},gantt:{fontSize:16,sectionFontSize:15,leftPadding:175,rightPadding:100,barHeight:28,barGap:10,topPadding:65},mindmap:{useMaxWidth:false}}));
 for(const item of manifest.diagrams){
  const input=path.resolve(base,item.source), assets=path.dirname(input), stem=path.basename(input,'.mmd'), source=fs.readFileSync(input,'utf8');
  const svg=await page.evaluate(async({source,stem})=>{
   document.getElementById('diagram').innerHTML='';
   const r=await mermaid.render(stem,source);
   document.getElementById('diagram').innerHTML=r.svg;
   const s=document.querySelector('#diagram svg');
   const box=s.viewBox.baseVal;
   s.style.width=(box.width||1200)+'px';s.style.height=(box.height||600)+'px';
   return s.outerHTML;
  },{source,stem});
  fs.writeFileSync(path.join(assets,stem+'.svg'),svg);
  await page.locator('#diagram svg').screenshot({path:path.join(assets,stem+'.png'),animations:'disabled'});
  console.log(stem+' renderizado');
 }
 await browser.close();
})().catch(e=>{console.error(e);process.exit(1)});
