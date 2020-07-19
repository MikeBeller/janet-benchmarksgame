num = 0
acc = 0
den = 0
for line in open("num10000"):
    f = line.strip().split()
    if f[0] == "NUM":
        num = int(f[1])
    elif f[0] == "DEN":
        acc = int(f[1])
    elif f[0] == "ACC":
        den = int(f[1])


x = 0
for i in range(1000):
    #x = (num * 3 + acc) // den
    x = num * den

print(x)
