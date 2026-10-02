// Evaluates one JavaScript expression in the app's page over Chrome DevTools and prints the result.
const expr = process.argv[2];
setTimeout(() => { console.log('(no answer)'); process.exit(2); }, 8000);
const pages = await (await fetch('http://127.0.0.1:9222/json')).json();
const page = pages.find(p => p.type === 'page');
const ws = new WebSocket(page.webSocketDebuggerUrl);
ws.onopen = () => ws.send(JSON.stringify({ id: 1, method: 'Runtime.evaluate', params: { expression: expr, returnByValue: true } }));
ws.onmessage = e => {
  const m = JSON.parse(e.data);
  if (m.id !== 1) return;
  const r = m.result && m.result.result;
  const v = r ? r.value : undefined;
  console.log(typeof v === 'string' ? v : JSON.stringify(v));
  process.exit(0);
};
