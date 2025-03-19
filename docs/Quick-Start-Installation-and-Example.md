# Installing PSGraph
Make sure you are running Powershell 5.0 (WMF 5.0) or Powershell 7+ (pwsh.exe).

    # Install PSGraph from the Powershell Gallery
    Find-Module PSGraph | Install-Module

    # Install GraphViz
    Install-GraphViz -Scope CurrentUser|AllUsers
    # Note, a warning may be written if chocolatey is not installed.
    # However, an older version of GraphViz will be used from nuget.org which should still work.
    # If you see this warning, considering installing chocolatey and then re-running to have newer Graphviz


# Generating your first graph

PSGraph has a unique syntax for defining a graph. This is because it was built specifically for the GraphViz engine. Here is a basic graph to get you started.

    # Import Module
    Import-Module PSGraph

    graph "myGraph" {
        edge start,middle,end
    } | Export-PSGraph -ShowGraph

This will create a new graph with three nodes linking each other.

[![Source](images/firstGraph.png)](images/firstGraph.png)

It will save it in the `$env:temp` folder because we did not specify a destination. It will then show the graph when it is done.
