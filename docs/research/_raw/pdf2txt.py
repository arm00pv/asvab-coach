import sys, urllib.request, io, re
from pypdf import PdfReader

UA = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36'}

def fetch(url):
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=90) as r:
        return r.read()

def main():
    url = sys.argv[1]
    out = sys.argv[2]
    data = fetch(url)
    if data[:4] == b'%PDF':
        reader = PdfReader(io.BytesIO(data))
        text = "\n".join((p.extract_text() or "") for p in reader.pages)
    else:
        text = data.decode('utf-8', 'replace')
    text = re.sub(r'[ \t]+', ' ', text)
    with open(out, 'w', encoding='utf-8') as f:
        f.write(text)
    print(f"{out} | {len(text)} chars")

main()
