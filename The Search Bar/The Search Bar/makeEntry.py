with open('AdjectiveAndNouns.plist', 'w+') as w:
    w.write('<?xml version="1.0" encoding="UTF-8"?>\n')
    w.write('<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n')
    w.write('<plist version="1.0">\n')
    w.write('<dict>')

    with open('adjectives', 'r') as adjectives:
        w.write('<key>adjectives</key>')

        w.write('<array>')
        for line in adjectives:
            adjective = line.strip('\n').split(' ')[0]
            w.write('<string>' + adjective + '</string>')
        w.write('</array>')

    with open('nouns', 'r') as nouns:
        w.write('<key>nouns</key>')

        w.write('<array>')
        for line in nouns:
            noun = line.strip('\n').split(' ')[0]
            w.write('<string>' + noun + '</string>')
        w.write('</array>')

    w.write('</dict>\n')
    w.write('</plist>')
