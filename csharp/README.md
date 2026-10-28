#### CSharp helpers

This repository is composed of 7 csharp projects
- LawCompiler *(generate "law.h" files from "law.xml" files)*
- GumpCompiler *(generate "gump.h" files from "gump.xml" files)*
- CMakeListGenerator *(generate CMakeList.txt from config.xml file)*
- PkgListLoader *(generate a specific loader for file pkglist.xml)*
- EclipseCDTSettings *(generate an eclipse cdt settings file for ArcBased projects)*
- WholeArchiveVCProj *(windows whole archive management)*
- WindowsPathResolver *(windows link path resolver)*

For the moment, we decide to push the binary of each project on git.
Binaries are portable linux/windows throught dotnet...

All projects are available with dotnet 6 unless WindowsPathResolver.

##### WindowsPathResolver
WindowsPathResolver is a windows os specific projet with COM dependencies.
So please compile its visual solution under windows.

Other projects could be easily update with dotnet publish.

##### LawCompiler, GumpCompiler and CMakeListGenerator
This 3 projects are based on xsd and T4 generators.
So we prowide a script to not pushed on git all those verbose csharp generated sources. This srcipt first generate sources from xsd and t4, then compile the project using dotnet publish and finaly clean the project (delete generated csharp sources). 
Using this script required mono for xsd part and axlstar (TextTransform) for t4 part. So axlstar must be clone at the same level that current app_buildsystem_tools.
Then using this script is quiet simple:

~~~{sh}
buildXSDT4CSProj.sh 'Law|Gump|CMakeList'
~~~

##### PkgListLoader, EclipseCDTSettings and WholeArchiveVCProj
This 3 projects are very simple they could be pulished directly. For instance:

~~~{sh}
cd PkgListLoader
dotnet publish
~~~
