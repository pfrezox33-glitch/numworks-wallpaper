import struct, zlib, sys
w=h=56
rows=[]
for y in range(h):
    row=bytearray([0])
    for x in range(w):
        if x < 3 or x >= 53 or y < 3 or y >= 53: c=(35,61,100)
        elif 10 <= y <= 43 and 10 <= x <= 46: c=(225,235,255)
        elif (x-19)**2+(y-19)**2 <= 20: c=(169,193,255)
        elif y > 28 and y < 42 and y > 40-abs(x-28)*0.8: c=(75,111,177)
        else: c=(225,235,255)
        row.extend(c)
    rows.append(bytes(row))
def chunk(t,d):
    return struct.pack(">I",len(d))+t+d+struct.pack(">I",zlib.crc32(t+d)&0xffffffff)
raw=b"".join(rows)
png=b"\x89PNG\r\n\x1a\n"+chunk(b"IHDR",struct.pack(">2I5B",w,h,8,2,0,0,0))+chunk(b"IDAT",zlib.compress(raw,9))+chunk(b"IEND",b"")
open(sys.argv[1],"wb").write(png)
