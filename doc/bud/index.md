# [`bud`][bud] command
The template incudes a convenient script for managing your system called [`bud`][bud].

It is a portable and highly composable system control tool that work anywhere on your host
or in the flake's devshell. 

Although it comes with some predefined standard helpers,
it is very extensible and you are encouraged to write your own script snippets
to ease your workflows. An example is the bud module for a `get` command that
comes included with `devos`.

While writing scripts you can convenientely access smart environment variables
that can tell the current architecture, user or host name, among others, regardless
wether you invoke `bud` within the devshell or as the system-wide installed `bud`.

For details, please review the [bud repo][bud].

## Usage
```sh
bud help
```


[bud]: https://github.com/divnix/bud
