*** Settings ***
Library    SeleniumLibrary
Library    webdriver_manager.chrome    WITH NAME   ChromeManager
Library    OperatingSystem

*** Test Cases ***
Open Browser And Visit URL
    # Set up driver using webdriver manager and specified options
    Install Webdriver And Set Driver Path
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --profile-directory\=Default
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --ignore-certificate-errors
    Call Method    ${options}    add_argument    --disable-web-security
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --no-service-autorun
    Call Method    ${options}    add_argument    --incognito
    #${user_agent}=    Set Variable    MyCustomUserAgentString
    #Call Method    ${options}    add_argument    --user-agent=${user_agent}
    Create WebDriver    Chrome    options=${options}

    # Navigate to URL and verify title
    Go To    https://www.example.com
    ${title}=    Get Title
    Should Be Equal    ${title}    Example Domain
    Close Browser

*** Keywords ***
Install Webdriver And Set Driver Path
    [Documentation]    Installs the webdriver for the specified BROWSER if not available and sets the driver path.
    ${BROWSER}=    Set Variable    Chrome
    ${IS_HEADLESS}=    Set Variable    false
    Set Global Variable    ${BROWSER}
    Set Global Variable    ${IS_HEADLESS}
    ${BROWSER_DRIVER_PATH}=    Run Keyword If    "${BROWSER.lower()}" == "chrome" or "${BROWSER.upper()}" == "CHROME"   Evaluate    webdriver_manager.chrome.ChromeDriverManager().install()
    ...    ELSE IF    "${BROWSER.lower()}" == "firefox" or "${BROWSER.upper()}" == "FIREFOX"   Evaluate    webdriver_manager.firefox.GeckoDriverManager().install()
    ...    ELSE IF    "${BROWSER.lower()}" == "edge" or "${BROWSER.upper()}" == "EDGE"   Evaluate    webdriver_manager.microsoft.EdgeChromiumDriverManager().install()
    ...    ELSE    Fail    Unsupported BROWSER: ${BROWSER}. Supported BROWSERS: Chrome, Firefox, Edge
    Run    mv ${BROWSER_DRIVER_PATH} /usr/local/bin/
#    Run    chmod 777 ${BROWSER_DRIVER_PATH}
#    Should Be Equal    ${result.rc}    0
    ${BROWSER_PATH}=    Set Variable    /usr/local/bin/chromedriver
    Run    chmod +x ${BROWSER_PATH}
    Set Global Variable    ${BROWSER_PATH}
