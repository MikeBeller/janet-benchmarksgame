/* The Computer Language Benchmarks Game
 * https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
 *
 * contributed by Denis Gribov
 *    a translation of the C program contributed by Mr Ledhug
 */

(function main() {

    //let n = +process.argv[2] || 10000,
    let n = scriptArgs[1] || 10000,
        i = 0,
        k = 0,
        acc = 0n,
        den = 1n,
        num = 1n,
        chr_0 = 48;

    let buf = new Uint8Array(10);
    let bufp = 0;

    while (i < n) {
        k++;

        let k2 = BigInt((k << 1) + 1);
        acc += num << 1n;
        acc = k2 * acc;
        den = k2 * den;
        num = BigInt(k) * num;

        if (num > acc) continue;

        let tmp = 3n * num + acc;
        //let d3 = tmp / den;   //use this line on node.js
        let tt = tmp, d3 = 0n; while (tt > den) { tt -= den; d3++; }  //this for qjs

        tmp = tmp + num;
        //let d4 = tmp / den;   // use this line for node.js
        let d4 = 0n; tt = tmp; while (tt > den) { tt -= den; d4++; }  // this for qjs

        if (d3 !== d4) continue;

        buf[bufp++] = Number(d3) + chr_0;

        if (++i % 10 === 0) {
            //process.stdout.write(buf);   // node.js
            std.out.write(buf.buffer, 0, 10);  // qjs
            console.log("\t:" + i);
            bufp = 0;
        }

        acc -= d3 * den;
        acc = 10n * acc;
        num = 10n * num;
    }
})();
