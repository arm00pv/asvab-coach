"""Pull DA Pam 611-21 chapter 10 section C (enlisted MOS specifications) and
print the roster, for re-verifying the catalogue in lib/data/repos/mos_data.dart.

    python docs/research/_raw/extract_ch10c.py            # summary + counts
    python docs/research/_raw/extract_ch10c.py --gates    # every gate sentence

WHY THE ARCHIVE. The pamphlet chapter files live on api.army.mil, which answers
HTTP 403 to anything that is not a browser. This fetches the Internet Archive
snapshot of the same URL, which serves the identical bytes.

WHY NOT THE ARMYPUBS URL. https://armypubs.army.mil/epubs/DR_pubs/DR_a/
ARN36922-PAM_611-21-000-WEB-2.pdf is 20 pages of cover, summary of change and
certification page. It contains no MOS data. The specifications are in the
chapter files below.

The extracted text is written to docs/research/_raw/ch10c.txt, which is
gitignored because it is 1.1 MB - the committed machine-readable extract is
docs/research/mos-roster-2025-12.json.
"""
import io
import os
import re
import sys
import urllib.request

UA = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
    'AppleWebKit/537.36 Chrome/126.0 Safari/537.36'
}

BUILDS = {
    '2024-11-20': 'https://api.army.mil/e2/c/downloads/2024/11/20/'
    'bf11d2d2/chapter-10c-enlisted-mos-specifications.pdf',
    '2025-12-04': 'https://api.army.mil/e2/c/downloads/2025/12/04/'
    '20612de5/chapter-10c-enlisted-mos-specifications.pdf',
}


def fetch(url):
    req = urllib.request.Request('https://web.archive.org/web/2026id_/' + url,
                                 headers=UA)
    return urllib.request.urlopen(req, timeout=300).read()


def text_of(pdf_bytes):
    from pypdf import PdfReader
    reader = PdfReader(io.BytesIO(pdf_bytes))
    return '\n'.join((page.extract_text() or '') for page in reader.pages)


def entries(full):
    """Section start = a 10-XXX heading followed by the code repeated.

    Some entries are laid out so that the 10-XXX. marker is swallowed by the
    preceding table (17E, 25E, 25H, 42S in the 2025 build), so the fallback
    accepts "CODE--Title" with no heading marker.
    """
    starts = {}
    for m in re.finditer(r'10-(\d{2}[A-Z])\.', full):
        code = m.group(1)
        if code in starts:
            continue
        if re.match(r'\s*(?:MOS\s+)?' + code + r'\b', full[m.end():m.end() + 60]):
            starts[code] = m.start()
    for m in re.finditer(r'(?<![0-9A-Za-z])(\d{2}[A-Z])\s*(?:--|\u2013\u2014|\u2014)\s*'
                         r'([A-Z][A-Za-z][^,\n]{2,70})', full):
        starts.setdefault(m.group(1), m.start())
    order = sorted(starts.items(), key=lambda kv: kv[1])
    out = {}
    for i, (code, start) in enumerate(order):
        end = order[i + 1][1] if i + 1 < len(order) else len(full)
        out[code] = full[start:end]
    return out


def gate_sentence(body):
    flat = re.sub(r'\s+', ' ', body)
    m = re.search(r'Qualifying scores?\.?', flat)
    if m:
        tail = flat[m.start():]
        opat = re.search(r'OPAT', tail)
        return tail[: opat.start() if opat else 400].strip()
    m = re.search(r'[^.]{0,160}minimum score of[^.]{0,200}\.', flat)
    return m.group(0).strip() if m else '(no qualifying-score sentence)'


def main():
    build = '2025-12-04'
    print('fetching %s build via the Internet Archive ...' % build)
    full = text_of(fetch(BUILDS[build]))
    here = os.path.dirname(os.path.abspath(__file__))
    raw = os.path.join(here, '_raw')
    if not os.path.isdir(raw):
        os.makedirs(raw)
    io.open(os.path.join(raw, 'ch10c.txt'), 'w', encoding='utf-8').write(full)

    body = entries(full)
    non_mos = [c for c in body if c.startswith('00') or c.startswith('09')]
    senior = [c for c in body
              if (c.endswith('Z') or c in ('12A', '12X', '15K', '15L', '91X', '94W', '46Y'))
              and c not in non_mos]
    substantive = sorted(c for c in body if c not in non_mos and c not in senior)

    print('section headings: %d' % len(body))
    print('  position reporting / unqualified codes: %d %s' % (len(non_mos), sorted(non_mos)))
    print('  senior sergeant / supervisory codes:    %d %s' % (len(senior), sorted(senior)))
    print('  substantive enlisted MOS:               %d' % len(substantive))

    dart = io.open(
        os.path.join(here, '..', '..', 'lib', 'data', 'repos', 'mos_data.dart'),
        encoding='utf-8').read()
    carried = set(re.findall(r"code: '([0-9A-Z]+)'", dart))
    missing = [c for c in substantive if c not in carried]
    extra = sorted(c for c in carried if c not in substantive)
    print('carried by the app: %d' % len(carried))
    print('  in the pamphlet, missing from the app: %d %s' % (len(missing), missing))
    print('  in the app, not a substantive chapter code: %d %s' % (len(extra), extra))

    if '--gates' in sys.argv:
        for code in substantive:
            print('%s | %s' % (code, gate_sentence(body[code])))


if __name__ == '__main__':
    main()
