#include <janet.h>

static Janet arraymod_cfun_flip(int32_t argc, Janet *argv) {
    janet_fixarity(argc, 2);
    JanetArray *arr = janet_getarray(argv, 0);
    int32_t last = janet_getinteger(argv, 1);
    if (last >= arr->count)
        janet_panicf("flip index %d out of range [0,%d)", last, arr->count);
    Janet tmp;
    int32_t mx = last / 2;
    for (int32_t i = 0; i <= mx; i++) {
        tmp = arr->data[i];
        arr->data[i] = arr->data[last - i];
        arr->data[last - i] = tmp;
    }
    return argv[0];
}

static const JanetReg cfuns[] = {
    {"flip", arraymod_cfun_flip,
        "(arraymod/flip arr last)\n\nReverses items [0,last] of array arr"},
    {NULL, NULL, NULL}
};

JANET_MODULE_ENTRY(JanetTable *env) {
    janet_cfuns(env, "arraymod", cfuns);
}
