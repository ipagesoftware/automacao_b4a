@echo off
:: ===========================================================
:: CONFIGURAÇÕES INICIAIS
:: ===========================================================
setlocal enabledelayedexpansion
chcp 65001 >nul
:: Truque para gerar o caractere ESC (invisível/controle) necessário para o ANSI
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
mode con: cols=100 lines=40
:: Cor de fundo azul + texto branco
color 1F
:: Oculta o cursor
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
    "[Console]::CursorVisible = $false"

setlocal EnableExtensions EnableDelayedExpansion

title Instalação B4A - Java e Android

:: ===========================================================
:: VERIFICA ELEVAÇÃO PARA ADMINISTRADOR
:: ===========================================================

net session >nul 2>&1

if %errorlevel% neq 0 (

    echo.
    echo Solicitando privilégios de Administrador...
    echo.

    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
        "Start-Process -FilePath '%~f0' -Verb RunAs"

    exit /b
)


:: ===========================================================
:: CONFIGURAÇÕES DOS ARQUIVOS
:: ===========================================================

set "PASTA_DOWNLOAD=%~dp0%download"
if not exist %PASTA_DOWNLOAD% (
    mkdir %PASTA_DOWNLOAD%
)

set "JDK_FILE=jdk-19.0.2.zip"
set "JDK_URL=https://www.ipagesoftware.com.br/produtos/windows/b4a/jdk-19.0.2.zip"

set "CMDTOOLS_FILE=commandlinetools-win-13114758_latest.zip"
set "CMDTOOLS_URL=https://www.ipagesoftware.com.br/produtos/windows/b4a/commandlinetools-win-13114758_latest.zip"

set "RESOURCES_FILE=resources_7_25.zip"
set "RESOURCES_URL=https://www.ipagesoftware.com.br/produtos/windows/b4a/resources_7_25.zip"

set "B4A_FILE=B4A.exe"
set "B4A_URL=https://www.ipagesoftware.com.br/produtos/windows/b4a/B4A.exe"

:: ===========================================================
:: VERIFICA / BAIXA JDK
:: ===========================================================
call :BAIXAR "%JDK_FILE%" "%JDK_URL%"
echo.
call :BAIXAR "%CMDTOOLS_FILE%" "%CMDTOOLS_URL%"
echo.
call :BAIXAR "%RESOURCES_FILE%" "%RESOURCES_URL%"
echo.
call :BAIXAR "%B4A_FILE%" "%B4A_URL%"
echo.

:: ===========================================================
:: MENU PRINCIPAL
:: ===========================================================

:MENU
cls
color 1F
echo.
echo.
echo ╔═════════════════════════════════════════════════════════════════════════════════════════════════╗
echo ║                                        MENU DE INSTALAÇÃO                                       ║
echo ╠═════════════════════════════════════════════════════════════════════════════════════════════════╣
echo ║                                                                                                 ║
echo ║ 1 - INSTALAÇÃO COMPLETA (Java + Android + Command Line Tools + B4A).                            ║
echo ║                                                                                                 ║
echo ║ 2 - PACOTE JAVA (Instala apenas o Java).                                                        ║
echo ║                                                                                                 ║
echo ║ 3 - PACOTE ANDROID (Android + Command Line Tools)..                                             ║
echo ║                                                                                                 ║
echo ║ 4 - PACOTE JAVA + ANDROID (Java + Android + Command Line Tools).                                ║
echo ║                                                                                                 ║
echo ║ 5 - SOMENTE B4A (Instala apenas o B4A).                                                         ║
echo ║                                                                                                 ║
echo ║ 0 - SAIR (Encerra esta aplicação).                                                              ║
echo ║                                                                                                 ║
echo ║                                                                                                 ║
echo ╚═════════════════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo.
choice /C 123450 /N /M "Escolha uma opção: "

if errorlevel 6 goto SAIR
if errorlevel 5 set "INSTALAR=5" & goto PREPARAR
if errorlevel 4 set "INSTALAR=4" & goto PREPARAR
if errorlevel 3 set "INSTALAR=3" & goto PREPARAR
if errorlevel 2 set "INSTALAR=2" & goto PREPARAR
if errorlevel 1 set "INSTALAR=1" & goto PREPARAR


:: ===========================================================
:: PREPARA INSTALAÇÃO
:: ===========================================================

:PREPARAR

cls

echo.
call :TITLE "INSTALACAO DO AMBIENTE B4A" 100
echo.

echo Pasta do instalador:
echo %PASTA_DOWNLOAD%
echo.

:: ===========================================================
:: VERIFICA B4A_Pacote.zip
:: ===========================================================

if not exist "%PASTA_DOWNLOAD%\B4A.exe" (
    cls
    echo.
    color 4F
    echo ╔══════════════════════════════════════════════════════════╗
    echo ║                          ATENÇÃO                         ║
    echo ╠══════════════════════════════════════════════════════════╣
    echo ║                                                          ║
    echo ║ ERRO:                                                    ║
    echo ║ %PASTA_DOWNLOAD%\B4A.exe nao foi encontrado.             ║
    echo ║                                                          ║
    echo ╚══════════════════════════════════════════════════════════╝
    echo.    
    pause
    goto MENU
)

:: ===========================================================
:: VERIFICA ARQUIVOS BAIXADOS
:: ===========================================================

if not exist "%PASTA_DOWNLOAD%\jdk-19.0.2.zip" (
    cls
    echo.
    color 4F
    echo ╔══════════════════════════════════════════════════════════╗
    echo ║                          ATENÇÃO                         ║
    echo ╠══════════════════════════════════════════════════════════╣
    echo ║                                                          ║
    echo ║ ERRO:                                                    ║
    echo ║ %PASTA_DOWNLOAD%\jdk-19.0.2.zip não foi encontrado.      ║
    echo ║                                                          ║
    echo ╚══════════════════════════════════════════════════════════╝
    echo.    
    pause
    goto MENU
)

if  not exist "%PASTA_DOWNLOAD%\resources_7_25.zip" (
    cls
    echo.
    color 4F
    echo ╔══════════════════════════════════════════════════════════╗
    echo ║                          ATENÇÃO                         ║
    echo ╠══════════════════════════════════════════════════════════╣
    echo ║                                                          ║
    echo ║ ERRO:                                                    ║
    echo ║ %PASTA_DOWNLOAD%\resources_7_25.zip não foi encontrado.  ║
    echo ║                                                          ║
    echo ╚══════════════════════════════════════════════════════════╝
    echo.    
    pause
    goto MENU
)

if not exist "%PASTA_DOWNLOAD%\commandlinetools-win-13114758_latest.zip" (
    cls
    echo.
    color 4F
    echo ╔════════════════════════════════════════════════════════════════════════════════╗
    echo ║                                    ATENÇÃO                                     ║
    echo ╠════════════════════════════════════════════════════════════════════════════════╣
    echo ║                                                                                ║
    echo ║ ERRO:                                                                          ║
    echo ║ %PASTA_DOWNLOAD%\commandlinetools-win-13114758_latest.zip não foi encontrado.  ║
    echo ║                                                                                ║
    echo ╚════════════════════════════════════════════════════════════════════════════════╝
    echo.    
    pause
    goto MENU    
)

:: ===========================================================
:: INSTALACAO COMPLETA
:: ===========================================================

if "%INSTALAR%"=="1" goto INSTALAR_COMPLETO

:: ===========================================================
:: SOMENTE JAVA
:: ===========================================================

if "%INSTALAR%"=="2" goto INSTALAR_JAVA

:: ===========================================================
:: SOMENTE ANDROID
:: ===========================================================

if "%INSTALAR%"=="3" goto INSTALAR_ANDROID

:: ===========================================================
:: JAVA + ANDROID
:: ===========================================================

if "%INSTALAR%"=="4" goto INSTALAR_JAVA_ANDROID

:: ===========================================================
:: SOMENTE B4A
:: ===========================================================

if "%INSTALAR%"=="5" goto INSTALAR_B4A


:: ===========================================================
:: INSTALACAO COMPLETA
:: ===========================================================

:INSTALAR_COMPLETO

call :JAVA

if errorlevel 1 goto ERRO_INSTALACAO

call :ANDROID

if errorlevel 1 goto ERRO_INSTALACAO

call :B4A

if errorlevel 1 goto ERRO_INSTALACAO
goto FINAL

:: ===========================================================
:: JAVA + ANDROID
:: ===========================================================

:INSTALAR_JAVA_ANDROID

call :JAVA

if errorlevel 1 goto ERRO_INSTALACAO

call :ANDROID

if errorlevel 1 goto ERRO_INSTALACAO
goto FINAL

:: ===========================================================
:: JAVA
:: ===========================================================

:INSTALAR_JAVA
call :JAVA
if errorlevel 1 goto ERRO_INSTALACAO
goto FINAL

:: ===========================================================
:: ANDROID
:: ===========================================================

:INSTALAR_ANDROID

call :ANDROID

if errorlevel 1 goto ERRO_INSTALACAO
goto FINAL

:: ===========================================================
:: B4A
:: ===========================================================

:INSTALAR_B4A
call :B4A

if errorlevel 1 goto ERRO_INSTALACAO
goto SAIR

:: ===========================================================
:: FUNCAO - INSTALAR JAVA
:: ===========================================================

:JAVA
cls
echo %ESC%[6;0H
echo.
echo.
echo ╔═══════════════════════════════════════════════════════════════════════════════════════════╗
echo ║                               INSTALANDO PACOTE OPENJDK                                   ║
echo ╠═══════════════════════════════════════════════════════════════════════════════════════════╣
echo ║                                                                                           ║
echo ║ O OpenJDK 19 é o ambiente Java que fornece ao B4A as ferramentas necessárias              ║
echo ║ para transformar o código do aplicativo em um APK Android.                                ║
echo ║                                                                                           ║
echo ║ Java 19: versão do Java na qual o pacote é baseado.                                       ║
echo ║                                                                                           ║
echo ║ JDK: contém as ferramentas necessárias para compilar e executar programas Java.           ║
echo ║ OpenJDK: distribuição aberta e gratuita do Java.                                          ║
echo ║ Inclui: JVM (Java Virtual Machine), compilador javac, bibliotecas Java e outras           ║
echo ║ ferramentas de desenvolvimento.                                                           ║
echo ║                                                                                           ║
echo ║ No seu projeto B4A: ele fornece o ambiente Java necessário para que o B4A (Basic4Android) ║
echo ║ possa compilar os aplicativos Android.                                                    ║
echo ║                                                                                           ║
echo ║ Aguarde alguns segundos para a conclusão da instalação.                                   ║
echo ║                                                                                           ║
echo ╚═══════════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo.

if not exist "C:\Java" (
    mkdir "C:\Java"
)

powershell.exe -NoProfile -ExecutionPolicy Bypass ^
    -Command "Expand-Archive -LiteralPath '%PASTA_DOWNLOAD%\jdk-19.0.2.zip' -DestinationPath 'C:\Java' -Force"

if errorlevel 1 (
    cls
    echo.
    color 4F
    echo ╔══════════════════════════════════════════════════════════╗
    echo ║                        ATENÇÃO                           ║
    echo ╠══════════════════════════════════════════════════════════╣
    echo ║                                                          ║
    echo ║ ERRO:                                                    ║
    echo ║ Falha ao instalar o Java.                     .          ║
    echo ║                                                          ║
    echo ╚══════════════════════════════════════════════════════════╝
    color 1F
    echo.
    del /q "%DESTINO%.download" >nul 2>&1
    exit /b 1  
)


if "%INSTALAR%"=="2" (
    cls
    echo.
    color 1F
    echo ╔══════════════════════════════════════════════════════════╗
    echo ║                        ATENÇÃO                           ║
    echo ╠══════════════════════════════════════════════════════════╣
    echo ║                                                          ║
    echo ║ SUCCESS:                                                 ║
    echo ║ Pacote OpenJDK instalado com sucesso.                    ║
    echo ║                                                          ║
    echo ╚══════════════════════════════════════════════════════════╝
    echo.    
    pause
    goto MENU
)

exit /b 0


:: ===========================================================
:: FUNCAO - INSTALAR ANDROID
:: ===========================================================

:ANDROID
cls
echo %ESC%[6;0H
echo.
echo.
echo ╔═══════════════════════════════════════════════════════════════════════════════════════════╗
echo ║                               INSTALANDO O ANDROID SDK                                    ║
echo ╠═══════════════════════════════════════════════════════════════════════════════════════════╣
echo ║ SDK do Android + Recursos Necessários                                                     ║
echo ║                                                                                           ║
echo ║ O Android SDK (Software Development Kit) é o conjunto de ferramentas fornecido            ║
echo ║ pelo Android para desenvolver, compilar, testar e gerar aplicativos Android.              ║
echo ║                                                                                           ║
echo ║                                                                                           ║
echo ║  * Android SDK: fornece as ferramentas necessárias para criar aplicativos                 ║
echo ║    para Android.                                                                          ║
echo ║                                                                                           ║
echo ║  * Ferramentas de compilação: permitem transformar o projeto em um aplicativo             ║
echo ║    Android, como um APK.                                                                  ║
echo ║                                                                                           ║
echo ║  * Recursos do Android: incluem bibliotecas, plataformas e componentes necessários        ║
echo ║    para a compilação.                                                                     ║
echo ║                                                                                           ║
echo ╚═══════════════════════════════════════════════════════════════════════════════════════════╝
echo.

if not exist "C:\Android" (
    mkdir "C:\Android"
)

powershell.exe -NoProfile -ExecutionPolicy Bypass ^
    -Command "Expand-Archive -LiteralPath '%PASTA_DOWNLOAD%\resources_7_25.zip' -DestinationPath 'C:\Android' -Force"

if errorlevel 1 (
    cls
    echo.
    color 4F
    echo ╔══════════════════════════════════════════════════════════╗
    echo ║                          ATENÇÃO                         ║
    echo ╠══════════════════════════════════════════════════════════╣
    echo ║                                                          ║
    echo ║ ERRO:                                                    ║
    echo ║ Falha ao instalar o Android.                  .          ║
    echo ║                                                          ║
    echo ╚══════════════════════════════════════════════════════════╝
    color 1F
    echo.
    exit /b 1 
)

cls
echo %ESC%[6;0H
echo.
echo.
echo ╔═══════════════════════════════════════════════════════════════════════════════════════════╗
echo ║                             INSTALAÇÃO ANDROID COMMAND LINE TOOLS                         ║
echo ╠═══════════════════════════════════════════════════════════════════════════════════════════╣
echo ║ SDK do Android + Recursos Necessários                                                     ║
echo ║                                                                                           ║
echo ║ O Android SDK (Software Development Kit) é o conjunto de ferramentas fornecido            ║
echo ║ pelo Android para desenvolver, compilar, testar e gerar aplicativos Android.              ║
echo ║                                                                                           ║
echo ║                                                                                           ║
echo ║  * Command Line Tools: permitem gerenciar o SDK e seus componentes através de ferramentas ║
echo ║    de linha de comando.                                                                   ║
echo ║                                                                                           ║
echo ║  * No seu projeto B4A: o SDK fornece ao B4A os componentes necessários para compilar      ║
echo ║    o código e gerar os aplicativos Android.                                               ║
echo ║                                                                                           ║
echo ╚═══════════════════════════════════════════════════════════════════════════════════════════╝
echo.


powershell.exe -NoProfile -ExecutionPolicy Bypass ^
    -Command "Expand-Archive -LiteralPath '%PASTA_DOWNLOAD%\commandlinetools-win-13114758_latest.zip' -DestinationPath 'C:\Android' -Force"

if errorlevel 1 (
    cls
    echo.
    color 4F
    echo ╔══════════════════════════════════════════════════════════╗
    echo ║                          ATENÇÃO                         ║
    echo ╠══════════════════════════════════════════════════════════╣
    echo ║                                                          ║
    echo ║ ERRO:                                                    ║
    echo ║ Falha ao instalar o Android Command Line Tools.          ║
    echo ║                                                          ║
    echo ╚══════════════════════════════════════════════════════════╝
    color 1F
    echo.
    del /q "%DESTINO%.download" >nul 2>&1
    exit /b 1 

)

if "%INSTALAR%"=="3" (
    cls
    echo.
    color 1F
    echo ╔════════════════════════════════════════════════════════════╗
    echo ║                        ATENÇÃO                             ║
    echo ╠════════════════════════════════════════════════════════════╣
    echo ║                                                            ║
    echo ║ SUCCESS:                                                   ║
    echo ║ Pacote Android + Command Line Tools instalado com sucesso. ║
    echo ║                                                            ║
    echo ╚════════════════════════════════════════════════════════════╝
    echo.    
    pause
    goto MENU
)

exit /b 0

:: ===========================================================
:: FUNCAO - INSTALAR B4A
:: ===========================================================

:B4A
cls
echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║              INSTALAÇÃO DO B4A (APENAS O B4A SERÁ INSTALADO)                 ║
echo ╠══════════════════════════════════════════════════════════════════════════════╣
echo ║                                                                              ║
echo ║ O B4A é um Ambiente de Desenvolvimento Integrado (IDE) que permite           ║
echo ║ programar apps Android usando uma linguagem semelhante ao Visual Basic, em   ║
echo ║ vez do Java tradicional.                                                     ║
echo ║                                                                              ║
echo ║ O grande diferencial é que você escreve o código em BASIC e o B4A compila    ║
echo ║ automaticamente esse código para Java, gerando um aplicativo Android nativo  ║
echo ║ (um arquivo .apk) pronto para ser publicado na Google Play.                  ║
echo ║                                                                              ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

if not exist "%PASTA_DOWNLOAD%\B4A.exe" (
    cls
    echo.
    color 4F
    echo ╔══════════════════════════════════════════════════════════╗
    echo ║                   ERRO NA INSTALAÇÃO                     ║
    echo ╠══════════════════════════════════════════════════════════╣
    echo ║                                                          ║
    echo ║ O arquivo B4A não foi encontrado.                        ║
    echo ║ A instalação será encerrada sem o B4A.                   ║
    echo ║                                                          ║
    echo ╚══════════════════════════════════════════════════════════╝
    echo.
    exit /b 1
)

if not "%INSTALAR%"=="5" (
    choice /C SN /N /M "Deseja instalar o B4A? [S/N]: "
    echo.
    echo.
    if errorlevel 2 (
        goto MENU

    )
)
echo.
echo Instalando B4A aguarde...
echo.

start "" /wait "%PASTA_DOWNLOAD%\B4A.exe" /q

if errorlevel 1 (
    cls
    echo.
    color 4F
    echo ╔══════════════════════════════════════════════════════════╗
    echo ║                          ATENÇÃO                         ║
    echo ╠══════════════════════════════════════════════════════════╣
    echo ║                                                          ║
    echo ║ ERRO:                                                    ║
    echo ║ O instalador do B4A retornou um código de erro.          ║
    echo ║                                                          ║
    echo ╚══════════════════════════════════════════════════════════╝
    color 1F
    echo.
    exit /b 1
)

echo.
echo B4A instalado com sucesso.
echo.

exit /b 0


:: ===========================================================
:: ERRO
:: ===========================================================

:ERRO_INSTALACAO
cls
echo.
color 4F
echo ╔══════════════════════════════════════════════════════════╗
echo ║                   ERRO NA INSTALAÇÃO                     ║
echo ╠══════════════════════════════════════════════════════════╣
echo ║                                                          ║
echo ║ A instalação não foi concluída corretamente.             ║
echo ║ Os arquivos temporários serão mantidos para diagnóstico. ║
echo ║                                                          ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo.
choice /C SN /N /M "Deseja sair da aplicação? [S/N]: "
echo.
if errorlevel 2 (
    color 1F
    goto MENU

)
exit /b 1

:: ===========================================================
:: FINAL
:: ===========================================================

:FINAL
:: ===========================================================
:: FINAL
:: ===========================================================
cls
color 1F
echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║                  INSTALAÇÃO CONCLUÍDA                    ║
echo ╠══════════════════════════════════════════════════════════╣
echo ║                                                          ║

if "%INSTALAR%"=="1" (
echo ║ CONPONENTES INSTALADOS:                                  ║
echo ║                                                          ║
echo ║ [OK] Java                                                ║
echo ║ [OK] Android                                             ║
echo ║ [OK] Android Command Line Tools                          ║
echo ║ [OK] B4A                                                 ║
echo ║                                                          ║
echo ║ Java:                                                    ║
echo ║ C:\Java                                                  ║
echo ║                                                          ║
echo ║ Android:                                                 ║
echo ║ C:\Android                                               ║
echo ║                                                          ║

)

if "%INSTALAR%"=="2" (
    echo ║ CONPONENTE INSTALADO:                                    ║
    echo ║                                                          ║
    echo ║ [OK] Java                                                ║
    echo ║                                                          ║
    echo ║ Java:                                                    ║
    echo ║ C:\Java                                                  ║
    echo ║                                                          ║    

)

if "%INSTALAR%"=="3" (
    echo ║ CONPONENTES INSTALADOS:                                  ║
    echo ║                                                          ║
    echo ║ [OK] Android                                             ║
    echo ║ [OK] Android Command Line Tools                          ║
    echo ║                                                          ║
    echo ║ Android:                                                 ║
    echo ║ C:\Android                                               ║
    echo ║                                                          ║    
)

if "%INSTALAR%"=="4" (
    echo ║ CONPONENTES INSTALADOS:                                  ║
    echo ║                                                          ║
    echo ║ [OK] Java                                                ║
    echo ║ [OK] Android                                             ║
    echo ║ [OK] Android Command Line Tools                          ║
    echo ║                                                          ║
    echo ║ Java:                                                    ║
    echo ║ C:\Java                                                  ║
    echo ║                                                          ║
    echo ║ Android:                                                 ║
    echo ║ C:\Android                                               ║
    echo ║                                                          ║    
)

if "%INSTALAR%"=="5" (
    echo ║ CONPONENTE INSTALADO:                                    ║
    echo ║                                                          ║
    echo ║ [OK] B4A                                                 ║
    echo ║                                                          ║
)
echo ║                                                          ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

pause
goto MENU
exit /b 0

:: ===========================================================
:: SAIR
:: ===========================================================

:SAIR

cls

echo.
call :TITLE "INSTALAÇÃO B4A CANCELADA" 100
echo.
echo Nenhuma instalaço foi executada.
echo.
echo.
cls
echo.
color 4F
echo ╔══════════════════════════════════════════════════════════╗
echo ║                 INSTALAÇÃO B4A CANCELADA                 ║
echo ╠══════════════════════════════════════════════════════════╣
echo ║                                                          ║
echo ║ ATENÇÃO:                                                 ║
echo ║ Nenhuma instalação foi executada.                        ║
echo ║                                                          ║
echo ╚══════════════════════════════════════════════════════════╝
echo. 

::exit /b 0
exit 1

:BAIXAR

set "ARQUIVO=%~1"
set "URL=%~2"
set "DESTINO=%PASTA_DOWNLOAD%\%ARQUIVO%"

if exist "%DESTINO%" (
    echo [OK] %ARQUIVO% ja existe.
    exit /b 0
)

echo.
echo [DOWNLOAD] %ARQUIVO%
echo URL: %URL%
echo.

curl.exe -L --fail --retry 3 --retry-delay 2 ^
    --output "%DESTINO%.download" ^
    "%URL%"

if errorlevel 1 (
    cls
    echo.
    color 4F
    echo ╔══════════════════════════════════════════════════════════╗
    echo ║                          ATENÇÃO                         ║
    echo ╠══════════════════════════════════════════════════════════╣
    echo ║                                                          ║
    echo ║ ERRO:                                                    ║
    echo ║ Falha ao baixar o $ARQUIVO%.                  .          ║
    echo ║                                                          ║
    echo ╚══════════════════════════════════════════════════════════╝
    color 1F
    echo.
    del /q "%DESTINO%.download" >nul 2>&1
    exit /b 1    
)

if not exist "%DESTINO%.download" (
    cls
    echo.
    color 4F
    echo ╔══════════════════════════════════════════════════════════╗
    echo ║                          ATENÇÃO                         ║
    echo ╠══════════════════════════════════════════════════════════╣
    echo ║                                                          ║
    echo ║ ERRO:                                                    ║
    echo ║ O arquivo não foi criado.                     .          ║
    echo ║                                                          ║
    echo ╚══════════════════════════════════════════════════════════╝
    color 1F
    echo.
    del /q "%DESTINO%.download" >nul 2>&1
    exit /b 1      
)

move /y "%DESTINO%.download" "%DESTINO%" >nul

echo [OK] %ARQUIVO% baixado com sucesso.

exit /b 0

REM ============================================
REM :TITLE - Centraliza um texto na tela
REM Uso: call :TITLE "texto" largura
REM Ex.: call :TITLE "INSTALAÇÃO DO ANDROID" 100
REM ============================================
:TITLE
set "text=%~1"
set "width=%~2"

REM Se não passar a largura, usa 80 como padrão
if "%width%"=="" set "width=80"

REM Se não passar texto, usa espaço em branco
if "%text%"=="" set "text= "

REM Obtém o comprimento do texto
call :strlen "%text%" len

REM Calcula quantos espaços devem vir à esquerda
set /a "padding=(%width% - %len%) / 2"
if %padding% lss 0 set "padding=0"

REM Cria a linha de "=" com a largura desejada
set "line="
for /l %%i in (1,1,%width%) do set "line=!line!="

REM Cria a string de espaços para alinhar
set "spaces="
for /l %%i in (1,1,%padding%) do set "spaces=!spaces! "

REM Exibe o resultado
echo !line!
echo !spaces!!text!
echo !line!
exit /b

REM ============================================
REM :strlen - Retorna o tamanho de uma string
REM Uso: call :strlen "string" variavel_retorno
REM ============================================
:strlen
setlocal enabledelayedexpansion
set "str=%~1"
set "count=0"
:strlen_loop
if defined str (
    set "str=!str:~1!"
    set /a "count+=1"
    goto :strlen_loop
)
endlocal & set "%~2=%count%"
exit /b