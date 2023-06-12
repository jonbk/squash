*** Settings ***
Documentation    Simple test to perform a Google search
Library          SeleniumLibrary

*** Variables ***
${BROWSER}       chrome
${URL}           https://www.google.com
${SEARCH_TERM}   Robot Framework

*** Test Cases ***
Perform Google Search
    Open Browser    ${URL}    ${BROWSER}
    Close Browser