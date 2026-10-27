"""Pull DA Pam 611-21 chapter 8 section B (warrant officer MOS specifications)
and print the roster, for re-verifying lib/data/repos/warrant_mos_data.dart.

    python docs/research/extract_ch8b.py            # counts + every section heading
    python docs/research/extract_ch8b.py --brief    # per-occupation prerequisites

WHY THE ARCHIVE, AND WHY THIS SHAPE OF URL. api.army.mil answers HTTP 403 to
anything that is not a browser, exactly as it does for chapter 10 section C.
The Internet Archive serves the identical bytes, but its /web/<capture>id_/
replay path answers HTTP 429 to a scripted client while the plain
/web/<capture>/ path of the same capture answers 200 - which is why the URL
below is built the way it is, and why a failed fetch here is a rate limit and
not a missing document.

The capture of the 04 December 2025 build is 20260510211025 (1.4 MB,
application/pdf). The chapter-10 file used for the enlisted roster is the same
build, so the two halves of the catalogue cite one edition.

The extracted text is written to docs/research/_raw/wo/, which is gitignored
because it is 430 KB - the roster itself is committed, in
lib/data/repos/warrant_mos_data.dart, and test/warrant_mos_test.dart reads the
extract back when it is present.
"""
import io
import os
import re
import sys
import urllib.request

UA = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
                  'AppleWebKit/537.36 Chrome/126.0 Safari/537.36',
    'Accept': 'application/pdf,*/*',
}

CAPTURE = '20260510211025'
URL = ('https://web.archive.org/web/%s/https://api.army.mil/e2/c/downloads/'
       '2025/12/04/720183c2/chapter-8b-wo-specifications.pdf' % CAPTURE)

HERE = os.path.dirname(os.path.abspath(__file__))
RAW = os.path.join(HERE, '_raw', 'wo')


def fetch():
    req = urllib.request.Request(URL, headers=UA)
    body = urllib.request.urlopen(req, timeout=600).read()
    if body[:4] != b'%PDF':
        raise SystemExit('the archive did not serve a PDF (%d bytes)' % len(body))
    return body


def text_of(pdf_bytes):
    from pypdf import PdfReader
    reader = PdfReader(io.BytesIO(pdf_bytes))
    return '\n'.join((page.extract_text() or '') for page in reader.pages)


def sections(full):
    """Every 8-XXXX section, keyed by heading, split at the next heading."""
    flat = re.sub(r'[ \t]+', ' ', full)
    starts = [(m.start(), m.group(0)) for m in
              re.finditer(r'(?m)^[^\S\n]*8-\d{3,4}[A-Z]?\.', flat)]
    order = sorted(starts)
    out = []
    for i, (pos, _) in enumerate(order):
        end = order[i + 1][0] if i + 1 < len(order) else len(flat)
        out.append(flat[pos:end])
    return out


def main():
    if not os.path.isdir(RAW):
        os.makedirs(RAW)
    txt = os.path.join(RAW, 'chapter-8b-wo-specifications.txt')
    if os.path.exists(txt) and os.path.getsize(txt) > 100000:
        full = io.open(txt, encoding='utf-8').read()
        print('using the extract already on disk: %s' % txt)
    else:
        print('fetching the 04 December 2025 build via the Internet Archive ...')
        full = text_of(fetch())
        io.open(txt, 'w', encoding='utf-8').write(full)

    body = sections(full)
    codes = []
    for section in body:
        # A heading can run over several lines before the "a." paragraph starts,
        # and the aviation sections list several occupation codes in one heading
        # (8-152 carries six). Everything before the first "a." line is heading.
        heading = []
        for line in section.split('\n'):
            if re.match(r'\s*[a-h][ .]', line) and heading:
                break
            heading.append(line)
        codes.extend(re.findall(r'\b(\d{3}[A-Z])\b', '\n'.join(heading)))

    dart = io.open(os.path.join(HERE, '..', '..', 'lib', 'data', 'repos',
                                'warrant_mos_data.dart'), encoding='utf-8').read()
    carried = set(re.findall(r"code: '([0-9]{3}[A-Z])'", dart))
    excluded = set(re.findall(r"'([0-9]{3}[A-Z])':\s*\n", dart))

    print('section headings: %d' % len(body))
    print('occupation codes in those headings: %d' % len(set(codes)))
    print('carried by the app: %d' % len(carried))
    print('recorded as excluded: %d %s' % (len(excluded), sorted(excluded)))
    missing = sorted(set(codes) - carried - excluded)
    extra = sorted((carried | excluded) - set(codes))
    print('  in the chapter, neither carried nor excluded: %d %s'
          % (len(missing), missing))
    print('  carried or excluded, not in the chapter: %d %s'
          % (len(extra), extra))
    entries = dart.split('  Mos(')[1:]
    gated = []
    for entry in entries:
        code = re.search(r"code: '([0-9]{3}[A-Z])'", entry)
        if code and "gate: g(" in entry:
            gated.append(code.group(1))
    print('entries with a published line-score gate: %s' % sorted(gated))

    if '--brief' in sys.argv:
        for section in body:
            head = section.split('\n')[0].strip()
            flat = re.sub(r'\s+', ' ', section)
            print('##', head)
            for marker in ('b. Prerequisites.', 'c. ', '(1) WO1/CW2', 'g. Duties'):
                i = flat.find(marker)
                if i >= 0:
                    print('   ', flat[i:i + 260])


if __name__ == '__main__':
    main()
