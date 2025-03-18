function Install-GraphViz
{
    <#
        .Description
        Installs GraphViz package using online provider
        .Example
        Install-GraphViz
        .PARAMETER Scope
        Use -Scope CurrentUser to install as non-admin to appdata instead of program files.
        Unused on *Nix systems.
    #>
    [cmdletbinding( SupportsShouldProcess = $true, ConfirmImpact = "High" )]
    param(
        [ValidateSet('AllUsers', 'CurrentUser')]
        [string]
        $Scope = 'AllUsers'
    )

    process
    {
        try
        {
            if ( $IsOSX )
            {
                if ( $PSCmdlet.ShouldProcess( 'Install graphviz' ) )
                {
                    brew install graphviz
                }
            }
            else
            {
                if ( $PSCmdlet.ShouldProcess('Register Chocolatey provider and install graphviz' ) )
                {
                    if ( -Not ( Get-PackageSource | Where-Object ProviderName -eq 'Chocolatey' ) )
                    {
                        try {
                            Register-PackageSource -Name Chocolatey -ProviderName Chocolatey -Location http://chocolatey.org/api/v2/ -ErrorAction 'Stop'
                        } catch {
                            # We can still install graphviz from nuget.org, though it is more outdated than the choco one.
                            # as of writing (March 2025) choco has  12.2.1* and nuget.org has 2.1.38.* from 2016 BUT it still works.
                            $nugetSource = Get-PackageSource | Where-Object { $_.Location -like 'https://api.nuget.org/v*' }
                            if (-not $nugetSource) {
                                Write-Warning 'No nuget.org feed found to fall back on. Cannot install graphviz.'
                                throw
                            }

                            Write-Warning '------------------------------------------------------------'
                            Write-Warning $_
                            Write-Warning 'Could not register a Chocolatey package provider. Will fall back to the older nuget.org Graphviz package instead.'
                            Write-Warning 'If you see this error, considering installing chocolatey and then re-running this command to use the latest Graphviz.'
                            Write-Warning '------------------------------------------------------------'
                        }
                    }

                    Find-Package graphviz | Install-Package -Verbose -ForceBootstrap -Scope $Scope
                }
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSitem )
        }
    }
}
