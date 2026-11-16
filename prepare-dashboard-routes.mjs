// Static entry documents keep clean dashboard URLs reloadable on static hosting.
import {readFile,writeFile,mkdir} from 'node:fs/promises';
const html=(await readFile(new URL('./dist/index.html',import.meta.url),'utf8')).replace('<head>','<head><base href="/">');
for(const route of ['admin','admin/sellers','admin/riders','admin/orders','admin/delivery','admin/cash','rider','courier','seller','seller/onboarding','seller/products','seller/orders','seller/finance','seller/learning','seller/settings']){const dir=new URL('./dist/'+route+'/',import.meta.url);await mkdir(dir,{recursive:true});await writeFile(new URL('index.html',dir),html);}
console.log('Prepared 15 dashboard entry documents.');
