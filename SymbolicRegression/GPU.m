//
//  GPU.m
//  SymbolicRegression
//
//  Created by Michal Cisarik on 8/16/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//
#import "GPU.h"

@implementation GPU
- (id)init
{
    self = [super init];
    if (self) {
        queue = gcl_create_dispatch_queue(CL_DEVICE_TYPE_GPU,NULL);
        if (queue == NULL)
            queue = gcl_create_dispatch_queue(CL_DEVICE_TYPE_CPU, NULL);
        
        gpu = gcl_get_device_id_with_dispatch_queue(queue);
        clGetDeviceInfo(gpu, CL_DEVICE_NAME, 128, name, NULL);
        fprintf(stdout, "Created a dispatch queue using the %s\n", name);
        
        in = (float*)malloc(sizeof(cl_float) * NUM_VALUES);
//        for (int i = 0; i < NUM_VALUES; i++) {
//            in[i] = (cl_float)i;
//        }
        
        out = (float*)malloc(sizeof(cl_float) * NUM_VALUES);
        
//        mem_in  = gcl_malloc(sizeof(cl_float) * NUM_VALUES, in,
//                             CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR);
        
        mem_in  = gcl_malloc(sizeof(cl_float) * NUM_VALUES, NULL,CL_MEM_READ_ONLY);
        mem_out = gcl_malloc(sizeof(cl_float) * NUM_VALUES, NULL,CL_MEM_WRITE_ONLY);
    }
    return self;
}

-(float*) calculate:(int*)o a:(double*)a b:(double*)b len:(int)len {
    dispatch_sync(queue, ^{
        for (int i = 0; i < len; i++)
            in[i] = (cl_float)o[i];
        gcl_memcpy(mem_in,in, sizeof(cl_float) * len);
        size_t wgs;
        gcl_get_kernel_block_workgroup_info((__bridge void *)(gpucalculate_kernel),CL_KERNEL_WORK_GROUP_SIZE,sizeof(wgs),&wgs, NULL);
        printf("OpenCL determinded workgroup size: %lu.\n", (unsigned long)wgs);
        cl_ndrange range = {1,{0, 0, 0},{NUM_VALUES, 0, 0},{wgs, 0, 0}};
        
        gpucalculate_kernel(&range,(cl_float*)mem_in, (cl_float*)mem_out,(cl_float*)mem_in,(cl_float*)mem_in);
        
        gcl_memcpy(out, mem_out, sizeof(cl_float) * NUM_VALUES);
    });
    return out;
}
-(void)free{
    gcl_free(mem_in);
    gcl_free(mem_out);
    free(in);
    free(out);
}
@end

