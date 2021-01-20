import fileinput
import re
import sys

re_comment = re.compile(r'^\s*; \s? (?P<comment>.*)', re.VERBOSE)
re_code = re.compile(r'''
(?P<label>[.\w]+:?)? (\s+ (?P<op>\S+) (\s+ (?P<arg>[^;]*))? ((\s+ ; \s* (?P<comment>.*)))?)? $
''', re.VERBOSE)


def stripped(fd):
    for line in fd:
        yield line.rstrip()


for ln, line in enumerate(stripped(fileinput.input())):
    if not line:
        print()
        continue

    if mo := re_comment.match(line):
        print(line)
        continue

    if mo := re_code.match(line):
        data = {k: v if v is not None else '' for k, v in mo.groupdict().items()}
        if data['comment']:
            data['comment'] = '; {comment}'.format(**data)

        print('{label:16}{op:16}{arg:16}{comment}'.format(**data).rstrip())
    else:
        print(f'{ln}: failed: {line}', file=sys.stderr)
