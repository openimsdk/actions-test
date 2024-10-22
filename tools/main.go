package main

import (
    "fmt"
    "regexp"
    "strings"
)

// Function to classify and format release notes
func classifyReleaseNotes(body string) map[string][]string {
    result := map[string][]string{
        "feat":  {},
        "fix":   {},
        "chore": {},
        "other": {},
    }

    // Regular expression to extract PR number and URL
    rePR := regexp.MustCompile(`https://github\.com/[^\s]+/pull/(\d+)`)

    // Split the body into individual lines
    lines := strings.Split(body, "\n")

    for _, line := range lines {
        if strings.HasPrefix(line, "*") {
            var category string

            // Determine the category based on the prefix
            if strings.HasPrefix(line, "* feat") {
                category = "feat"
            } else if strings.HasPrefix(line, "* fix") {
                category = "fix"
            } else if strings.HasPrefix(line, "* chore") {
                category = "chore"
            } else {
                category = "other"
            }

            // Extract PR number and URL
            matches := rePR.FindStringSubmatch(line)
            if len(matches) == 2 {
                prURL := matches[0]
                prNumber := matches[1]
                // Format the line with the PR link
                formattedLine := fmt.Sprintf("* %s [#%s](%s)", strings.Split(line, " by ")[0][2:], prNumber, prURL)
                result[category] = append(result[category], formattedLine)
            } else {
                // If no PR link is found, just add the line as is
                result[category] = append(result[category], line)
            }
        }
    }

    return result
}

// Function to generate the final changelog
func generateChangelog(body string) string {
    sections := classifyReleaseNotes(body)

    changelog := "# Changelogs\n\n"
    if len(sections["feat"]) > 0 {
        changelog += "### New Features\n" + strings.Join(sections["feat"], "\n") + "\n\n"
    }
    if len(sections["fix"]) > 0 {
        changelog += "### Bug Fixes\n" + strings.Join(sections["fix"], "\n") + "\n\n"
    }
    if len(sections["chore"]) > 0 {
        changelog += "### Chores\n" + strings.Join(sections["chore"], "\n") + "\n\n"
    }
    if len(sections["other"]) > 0 {
        changelog += "### Others\n" + strings.Join(sections["other"], "\n") + "\n\n"
    }

    return changelog
}

func main() {
    // Example release notes content
    body := "## What's Changed\r\n* feat: Update version to v0.0.19 by @github-actions in https://github.com/openimsdk/actions-test/pull/30\r\n* Update version to v0.0.21 by @github-actions in https://github.com/openimsdk/actions-test/pull/32\r\n* fix: swm by @mo3et in https://github.com/openimsdk/actions-test/pull/34\r\n* feat: Update 66666 by @github-actions in https://github.com/openimsdk/actions-test/pull/66\r\n* T1 by @mo3et in https://github.com/openimsdk/actions-test/pull/35\r\n* update teset by @mo3et in https://github.com/openimsdk/actions-test/pull/36\r\n* hello by @mo3et in https://github.com/openimsdk/actions-test/pull/39\r\n* chore: rm by @mo3et in https://github.com/openimsdk/actions-test/pull/51\r\n* 21321 by @mo3et in https://github.com/openimsdk/actions-test/pull/53\r\n* 1x by @mo3et in https://github.com/openimsdk/actions-test/pull/54\r\n* Update CHANGELOG for release v0.0.34 by @github-actions in https://github.com/openimsdk/actions-test/pull/74"

    // Generate and print the formatted changelog
    changelog := generateChangelog(body)
    fmt.Println(changelog)
}
