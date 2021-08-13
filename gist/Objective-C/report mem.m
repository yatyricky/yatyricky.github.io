
    const void _ReportMemory()
    {
        struct mach_task_basic_info info;
        mach_msg_type_number_t size = MACH_TASK_BASIC_INFO_COUNT;
        kern_return_t kerr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &size);
        if (kerr == KERN_SUCCESS)
        {
            NSLog(@"NativeMemory: in use: %f", ((CGFloat)info.resident_size / 1048576));
            NSLog(@"NativeMemory: (virtual) in use: %f", ((CGFloat)info.virtual_size / 1048576));
        }
        else
        {
            NSLog(@"NativeMemory: Error with task_info(): %s", mach_error_string(kerr));
        }
    }

    const float _GetMemory()
    {
        struct mach_task_basic_info info;
        mach_msg_type_number_t size = MACH_TASK_BASIC_INFO_COUNT;
        kern_return_t kerr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &size);
        if (kerr == KERN_SUCCESS)
        {
            return (CGFloat)info.resident_size / 1048576;
        }
        else
        {
            return 0;
        }
    }

    const void _AllocTest()
    {
//        size_t arr_size = 26214400 * sizeof(int);
//        int *array = (int*)malloc(arr_size);
//        for (int i = 0; i < 26214400; i++) {
////            array[i] = 1;
//            void* discard = malloc(sizeof(int));
//        }
//        NSLog(@"NativeMemory: malloc %d", (int)arr_size);
//        free(array);
        NSLog(@"NativeMemory: doesn't work");
    }