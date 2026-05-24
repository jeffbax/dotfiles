function ui-prod-console
    ui-dev
    clear

    echo "Launching PROD console - don't try this at home!" \n | lolcat
    heroku run DB_STATEMENT_TIMEOUT=0 rails c -a user-interviews-prod -s performance-l
end
