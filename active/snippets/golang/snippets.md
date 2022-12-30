# GoLang Snippets

## goimports

```sh
go install golang.org/x/tools/cmd/goimports@latest
```

The -l flag tells goimports to print the files with incorrect formatting to the console. The -w flag tells goimports to modify the files in-place. The . specifies the files to be scanned: everything in the current directory and all of its subdirectories.
```sh
goimports -l -w .
```

## golint: Linting

Note that Linting is recommended as part of the code review process, not part of the automated CI/CD process as there are many false positives, etc.

```sh
go install golang.org/x/lint/golint@latest
```

```sh
golint ./...
```

## go vet: Vetting

Vetting, unlike lintintg can be used as part of the automatic CI/CD approval process.

```sh
go vet ./...
```

## combined golint and vetting

If you are familiar with golint and `go vet`, than you may want to look into golangci-lint. This combines those tools and over 8 othersd by default. Allowing another 50 or so based on your configuration.

ref: https://golangci-lint.run/usage/install/

```sh
go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.50.1
```

```sh
golangci-lint run
```
