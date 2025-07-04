package open_im_sdk

import "C"

// Hello returns a greeting message
//export Hello
func Hello(name string) string {
    return "Hello " + name + " from OpenIM SDK!"
}

// GetVersion returns the SDK version
//export GetVersion
func GetVersion() string {
    return "1.0.0"
}

func main() {} // Required for gomobile