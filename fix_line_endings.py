import sys

FILENAME=sys.argv[1]
STARTLINE=int(sys.argv[2])
ENDLINE=int(sys.argv[3])

LF = chr(10)
CR = chr(13)

NLS = { LF : "[LF]", CR : "[CR]" }

with open(FILENAME, 'r', newline='') as fh:
   contents = fh.readlines()

with open(FILENAME, 'w', newline='') as fh:
	for _idx, line in enumerate(contents):
		idx = _idx + 1
		if idx < STARTLINE or idx > ENDLINE:
			fh.write(line)
		else:
			print("###", idx)
			type=None
			linelen = len(line)
			endstr=""
			first_real=linelen
			for idx in range(linelen - 1, -1, -1):
				if line[idx] in NLS:
					endstr = NLS[line[idx]] + endstr
					first_real-=1
				else:
					break
			fh.write(line[:first_real])
			if endstr == "[CR][LF]": #dos
				fh.write(LF)
				pass
			elif endstr == "[LF]": #unix
				fh.write(CR)
				fh.write(LF)
				pass
			else: # bugger
				raise Exception("Weird LE: '{}' - '{}' on line {}".format(endstr, line, idx))
