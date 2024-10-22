// package main

// import (
// 	"fmt"
// )

// func main() {
// 	// Create a new GitHubRepo instance
// 	repoOwner := "openimsdk"
// 	repoName := "actions-test"
// 	repo := &GitHubRepo{Owner: repoOwner, Repo: repoName}

// 	// Fetch release data (you can pass a version or leave it empty for latest)
// 	version := "v0.0.33" // Example version
// 	releaseData, err := repo.fetchReleaseData(version)
// 	if err != nil {
// 		fmt.Println("Error fetching release data:", err)
// 		return
// 	}

// 	// Generate and print the formatted changelog
// 	changelog := repo.generateChangelog(releaseData.TagName, releaseData.Published, releaseData.HtmlUrl, releaseData.Body)
// 	fmt.Println(changelog)
// }
