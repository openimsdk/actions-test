package open_im_sdk_callback

// OnSuccess handles success callback
func OnSuccess(data string) {
	// Handle success
}

// OnError handles error callback
func OnError(errCode int, errMsg string) {
	// Handle error
}

// NewDefaultCallback creates a new default callback
func NewDefaultCallback() string {
	return "callback created"
}
