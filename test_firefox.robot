*** Settings ***
Library    SeleniumLibrary
Library    webdriver_manager.chrome    WITH NAME   ChromeManager
Library    webdriver_manager.firefox    WITH NAME   GeckoDriverManager
Library    OperatingSystem

*** Test Cases ***
Open Firefox
    Install Webdriver And Set Driver Path
    ${IS_HEADLESS}     Set Variable    True
    ${desired_capabilities}=    Create Dictionary
    ...    args    ["--disable-gpu", "--no-sandbox","--headless", "--disable-extensions", "--disable-dev-shm-usage", "--no-service-autorun"]
    ...    prefs    {"general.useragent.override": "rC[MtC~0>#<,JVm"}
    Create Webdriver    Firefox    desired_capabilities=${desired_capabilities}    executable_path=${BROWSER_DRIVER_PATH}
    Run Keyword If    ${IS_HEADLESS}    Set Window Size    1920    1080
    ...    ELSE    Maximize Browser Window
    Go To    https://www.google.com

*** Keywords ***
Install Webdriver And Set Driver Path
    [Documentation]    Installs the webdriver for the specified BROWSER if not available and sets the driver path.
    ${BROWSER}=    Set Variable    firefox
    ${IS_HEADLESS}=    Set Variable    false
    Set Global Variable    ${BROWSER}
    Set Global Variable    ${IS_HEADLESS}
    ${BROWSER_DRIVER_PATH}=    Run Keyword If    "${BROWSER.lower()}" == "chrome" or "${BROWSER.upper()}" == "CHROME"   Evaluate    webdriver_manager.chrome.ChromeDriverManager().install()
    ...    ELSE IF    "${BROWSER.lower()}" == "firefox" or "${BROWSER.upper()}" == "FIREFOX"   Evaluate    webdriver_manager.firefox.GeckoDriverManager().install()
    ...    ELSE IF    "${BROWSER.lower()}" == "edge" or "${BROWSER.upper()}" == "EDGE"   Evaluate    webdriver_manager.microsoft.EdgeChromiumDriverManager().install()
    ...    ELSE    Fail    Unsupported BROWSER: ${BROWSER}. Supported BROWSERS: Chrome, Firefox, Edge
#    Run    mv ${BROWSER_DRIVER_PATH} /usr/local/bin/
##    Run    chmod 777 ${BROWSER_DRIVER_PATH}
##    Should Be Equal    ${result.rc}    0
#    ${BROWSER_PATH}=    Set Variable    /usr/local/bin/geckodriver
#    Run    chmod +x ${BROWSER_PATH}
    Set Global Variable    ${BROWSER_DRIVER_PATH}