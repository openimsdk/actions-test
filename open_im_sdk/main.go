package open_im_sdk

import (
	_ "golang.org/x/mobile/bind" // 确保mobile包被保留
)

// Hello returns a greeting message
func Hello(name string) string {
	return "Hello " + name + " from OpenIM SDK!"
}

// GetVersion returns the SDK version
func GetVersion() string {
	return "1.0.0"
}
