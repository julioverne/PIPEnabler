#import <dlfcn.h>
#import <objc/runtime.h>
#import <substrate.h>

static const CFStringRef kPicInPic = CFSTR("nVh/gwNpy7Jv1NOk00CMrw");

static Boolean (*MGGetBoolAnswer_o)(CFStringRef property);
static Boolean MGGetBoolAnswer_r(CFStringRef property)
{
	Boolean ret = MGGetBoolAnswer_o(property);
	if(CFEqual(property, kPicInPic)) {
		ret = true;
	}
	return ret;
}

%ctor
{
	MSHookFunction((void *)(dlsym(RTLD_DEFAULT, "MGGetBoolAnswer")), (void *)MGGetBoolAnswer_r, (void **)&MGGetBoolAnswer_o);
}
