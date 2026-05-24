function ui-start
    ui-dev

    bundle

    yarn install

    ui-migrate-local

    rails db:seed

    #rails elasticsearch:development_reindex;
    echo \n\n "Let's get crack-a-lack-in'!" \n | lolcat
end
