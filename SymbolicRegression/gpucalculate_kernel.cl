kernel void gpucalculate(global float *operation,
                 global float *a,
                 global float *b,
                 global float *out) {
    size_t i = get_global_id(0);
    a[i] = operation[i] * operation[i];
//    size_t i = get_global_id(0);
//    int o = operation[i];
//    
//    if (o==0)
//        out[i]=a[i]+b[i];
//    if (o==1)
//        out[i]=a[i]-b[i];
//    if (o==2)
//        out[i]=a[i]*b[i];
//    if (o==3)
//        out[i]=a[i]/b[i];
//    if (o==4)
//        out[i]=log(a[i]);
//    if (o==5)
//        out[i]=sin(a[i]);
//    if (o==6)
//        out[i]=cos(a[i]);
//    if (o==7)
//        out[i]=tan(a[i]);
}