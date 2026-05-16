from libc.math cimport powf, sinf

cdef public float fun_el "fun_el" (int k, float x):
    return powf(x, -(<float>k)) / sinf((<float>k) * x)