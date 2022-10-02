import re


def to_css_var(name):
    head, *rest = re.split(r'([A-Z])', name)
    pairs = list(map(lambda pair: pair[0].lower() + pair[1],
        zip(rest[::2], rest[1::2])))
    return f"--{head}-{'-'.join(pairs)}"

def process_line(line):
    name, hex_color = line.split()

    return f'{to_css_var(name)}: {hex_color};'


def main():
    with open('colors.md') as f:
        lines = f.read().strip().split('\n')

    print(*map(process_line, lines), sep='\n')


if __name__ == '__main__':
    main()
