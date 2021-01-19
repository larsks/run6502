import re
import sys

re_include = re.compile(r'\s+\.include\s+"(?P<include>[^"]+)".*')


for src in sys.argv[1:]:
    inc = []
    with open(src) as fd:
        for line in fd:
            if mo := re_include.match(line):
                inc.append(mo.group('include'))

    print(f'{src.replace(".s", ".o")}: {src} {" ".join(inc)}')
