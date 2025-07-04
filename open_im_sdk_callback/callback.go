package open_im_sdk_callback

import "C"

// CallbackInterface defines callback methods
type CallbackInterface interface {
	OnSuccess(data string)
	OnError(errCode int, errMsg string)
}

// DefaultCallback implements CallbackInterface
type DefaultCallback struct{}

// OnSuccess handles success callback
//
//export OnSuccess
func OnSuccess(data string) {
	// Handle success
}

// OnError handles error callback
//
//export OnError
func OnError(errCode int, errMsg string) {
	// Handle error
}

// NewDefaultCallback creates a new default callback
func NewDefaultCallback() *DefaultCallback {
	return &DefaultCallback{}
}

func main() {} // Required for gomobile
