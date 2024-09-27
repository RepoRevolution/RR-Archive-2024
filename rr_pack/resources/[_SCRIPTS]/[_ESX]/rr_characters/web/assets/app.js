var config = null;
var data = {
    characters: [],
    slots: 0
};
var availableSlots = 0;
var isBusy = false;

function root() { 
    $('#root').html(`
        <section id="multiCharacter">
            <div class="character-select">
                <p class="character-select-title">SELECT CHARACTER</p>
                <div id="characters" class="character-select-list"></div>
            </div>
            <div class="character-info">
                <p class="character-info-title">Character info <span class="material-symbols-outlined">person</span></p>
                <div id="characterInfo"></div>
            </div>
            <div class="character-buttons"></div>
            <div id="deleteModal" class="character-delete-modal">
                <div class="character-delete">
                    <p class="character-delete-text">Are you sure to delete this character? This process is not reversible!</p>
                    <div class="character-delete-buttons">
                        <button class="character-delete-button button-delete" data-action="delete"><span class="material-symbols-outlined">delete</span></button>
                        <button class="character-delete-button" data-action="cancel"><span class="material-symbols-outlined">close</span></button>
                    </div>
                </div>
            </div>
        </section>
        <section id="identity">
            <div class="character-creator">
                <p class="character-creator-title">CREATE CHARACTER</p>
                <form id="characterCreation" class="character-creator-form"></form>
            </div>
        </section>
    `);
}

function dataURL(url, callback) {
    var xhr = new XMLHttpRequest();
    xhr.onload = function() {
        var reader = new FileReader();
        reader.onloadend = function() {
            callback(reader.result);
        }
        reader.readAsDataURL(xhr.response);
    };
    xhr.open("GET", url);
    xhr.responseType = "blob";
    xhr.send();
}

function buildUI(configuration){
    config = configuration;
    
    var l = config.locale
    $('.character-select-title').text(l.ui_select_title);
    $('.character-info-title').html(`${l.ui_info_title} <span class="material-symbols-outlined">person</span>`);
    $('.character-creator-title').text(l.ui_create_title);
    $('.character-delete-text').text(l.ui_delete_confirmation);

    var v = config.validation_data
    $('#characterCreation').append(`
        <p class="character-creator-form-text"><span class="material-symbols-outlined">id_card</span> ${l.ui_create_category_personals}</p>
        <div class="character-creator-form-group">
            <div class="character-creator-input-group">
                <label for="firstName">${l.ui_create_first_name}</label>
                <input id="firstName" class="character-creator-form-input" type="text" pattern="[A-Za-z]{${v.max_name_length}}">
            </div>
            <div style="width: 5%;"></div>
            <div class="character-creator-input-group">
                <label for="lastName">${l.ui_create_last_name}</label>
                <input id="lastName" class="character-creator-form-input" type="text" pattern="[A-Za-z]{${v.max_name_length}}">
            </div>
        </div>
        <div class="character-creator-form-group">
            <div class="character-creator-input-group">
                <label for="sex">${l.ui_create_sex}</label>
                <select id="sex" class="character-creator-form-input">
                    <option value="m">${l.ui_create_sex_male}</option>
                    <option value="f">${l.ui_create_sex_female}</option>
                </select>
            </div>
            <div style="width: 5%;"></div>
            <div class="character-creator-input-group">
                <label for="height">${l.ui_create_height}</label>
                <input id="height" class="character-creator-form-input" type="number" min="${v.min_height}" max="${v.max_height}" placeholder="${v.min_height}cm - ${v.max_height}cm">
            </div>
        </div>
        <p class="character-creator-form-text"><span class="material-symbols-outlined">person_pin</span> ${l.ui_create_category_origin}</p>
        <div class="character-creator-form-group">
            <div class="character-creator-input-group">
                <label for="birthDate">${l.ui_create_birth_date}</label>
                <input id="birthDate" class="character-creator-form-input" type="date" min="${v.lowest_year}-01-01" max="${v.highest_year}-12-31" pattern="${v.date_format}">
            </div>
            <div style="width: 5%;"></div>
            <div class="character-creator-input-group">
                <label for="nationality">${l.ui_create_nationality}</label>
                <select id="nationality" class="character-creator-form-input"></select>
            </div>
        </div>
        <p class="character-creator-form-text"><span class="material-symbols-outlined">pin_drop</span> ${l.ui_create_category_start_info}</p>
        <div class="character-creator-form-group">
            <div class="character-creator-input-group">
                <label for="spawnPoint">${l.ui_create_spawn_point}</label>
                <select id="spawnPoint" class="character-creator-form-input"></select>
            </div>
            <div style="width: 5%;"></div>
            <div class="character-creator-input-group">
                <label for="class">${l.ui_create_class}</label>
                <select id="class" class="character-creator-form-input"></select>
            </div>
        </div>
        <p id="creatorError" class="character-creator-form-notify" style="display: none;"></p>
        <div class="character-creator-form-buttons">
            <button class="character-creator-form-button button-delete" data-action="reset"><span class="material-symbols-outlined">restart_alt</span></button>
            <button class="character-creator-form-button" data-action="create"><span class="material-symbols-outlined">done</span></button>
            <button class="character-creator-form-button button-delete" data-action="cancel"><span class="material-symbols-outlined">close</span></button>
        </div>
    `);

    for (let i = 0; i < config.nationalities.length; i++) {
        const value = config.nationalities[i];
        $('#nationality').append(
            `<option value="${i}">${value}</option>`
        );
    }

    for (let i = 0; i < config.spawn_points.length; i++) {
        const value = config.spawn_points[i];
        $('#spawnPoint').append(
            `<option value="${i}">${value.label}</option>`
        );
    }

    for (const [id, obj] of Object.entries(config.classes)) {
        $('#class').append(
            `<option value="${id}">${obj.label}</option>`
        );
    }
}

function resetUI() {
    $('#root').fadeOut();
    setTimeout(function(){
        $('#multiCharacter').hide();
        $('#characters').html('');
        $('.character-info').hide();
        $('#characterInfo').html('');
        $('.character-buttons').html('').hide();
        $('#deleteModal').hide();
        $('#identity').hide();
        $('#characterCreation')[0].reset();
        $('.character-creator-form-input').removeClass('error');
    }, 1000)
}

function playTime(seconds) {
    if (seconds) {
        var minutes = Math.floor(seconds / 60);
        var hours = Math.floor(minutes / 60);
        var days = Math.floor(hours / 24);

        if (days > 0) {
            seconds -= minutes * 60;
            minutes -= hours * 60;
            hours -= days * 24;
            return `${days}d ${hours < 10 ? '0' + hours : hours}:${minutes < 10 ? '0' + minutes : minutes}:${seconds < 10 ? '0' + seconds : seconds}`;
        } else if (hours > 0) {
            seconds -= minutes * 60;
            minutes -= hours * 60;
            return `${hours < 10 ? '0' + hours : hours}:${minutes < 10 ? '0' + minutes : minutes}:${seconds < 10 ? '0' + seconds : seconds}`;
        } else if (minutes > 0) {
            seconds -= minutes * 60;
            return `00:${minutes < 10 ? '0' + minutes : minutes}:${seconds < 10 ? '0' + seconds : seconds}`;
        } else if (seconds > 0) {
            return `00:00:${seconds < 10 ? '0' + seconds : seconds}`;
        } else return '00:00:00';
    } else return '00:00:00';
}

function lastSeen(timestamp) {
    var l = config.locale
    if (timestamp) {
        const currentDate = new Date();
        const inputDate = new Date(timestamp);

        const timeDifference = currentDate - inputDate;
        const seconds = Math.floor(timeDifference / 1000);
        const minutes = Math.floor(seconds / 60);
        const hours = Math.floor(minutes / 60);
        const days = Math.floor(hours / 24);

        if (days > 0) {
            if (days == 1) {
                return `${l.ui_last_seen_yesterday}`;
            } else return `${days} ${l.ui_last_seen_days} ${l.ui_last_seen_ago}`;
        } else if (hours > 0) {
            return `${hours}h ${l.ui_last_seen_ago}`;
        } else if (minutes > 0) {
            return `${minutes}m ${l.ui_last_seen_ago}`;
        } else if (seconds > 0) {
            return `${seconds}s ${l.ui_last_seen_ago}`;
        } else return `${l.ui_last_seen_never}`;
    } else return `${l.ui_last_seen_never}`;
}

function getCharactersCount(characters) {
    let count = 0
    if (characters) {
        characters.forEach(character => {
            if (character != null && character != undefined) {
                count += 1
            }
        });
    }
    return count
}

function openUI(characters, slots) {
    data.slots = slots
    const count = getCharactersCount(characters)
    availableSlots = slots - count
    $('#root').show();

    var l = config.locale
    if (availableSlots > 0) {
        $('#characters').append(`
            <div class="character-select-option" data-id="0">
                <img class="character-select-option-image" src="./images/man.png" width="75px" height="75px">
                <div class="character-select-option-texts">
                    <p class="character-select-option-title">${l.ui_create_character}</p>
                    <p class="character-select-option-text">${l.ui_available_slots}: <span>${availableSlots}</span></p>
                </div>
            </div>
        `);
    }

    if (characters && characters.length > 0) {
        for (const [id, character] of Object.entries(characters)) {
            var numberId = Number(id) + 1
            if (character) {
                $('#characters').append(`
                    <div class="character-select-option" data-id="${numberId}">
                        <img class="character-select-option-image" src="${(character.mugshot != null ? character.mugshot : (character.sex == 0 ? "./images/man.png" : "./images/woman.png"))}" width="75px" height="75px">
                        <div class="character-select-option-texts">
                            <p class="character-select-option-title">${character.name}</p>
                            <p class="character-select-option-text">${l.ui_play_time}: <span>${playTime(character.play_time)}</span></p>
                            <p class="character-select-option-text">${l.ui_last_seen}: <span>${lastSeen(character.last_seen)}</span></p>
                        </div>
                    </div>
                `);
                data.characters[numberId] = character
            }
        }
    }
    $('#multiCharacter').show();

    $.post(`https://${GetParentResourceName()}/loaded`, JSON.stringify({}));
}

function changeSpawnCamera(id) {
    if (id == undefined || id == null) return;
    var spawnPoint = config.spawn_points[id];
    if (spawnPoint) {
        $.post(`https://${GetParentResourceName()}/changeSpawnCamera`, JSON.stringify(id));
    }
}

function changeClassDescription(id) {
    if (!id) return;
    var data = config.classes[id]
    if (!data) return;
    $('.character-creator-form-notify').fadeOut();
    setTimeout(function(){
        $('.character-creator-form-notify').removeClass('danger', 'warning').addClass('warning').text(data.description).fadeIn();
    }, 1000);
}

window.onload = function(e) {
    root();

    window.addEventListener("message", function(e) {
        const msg = e.data
        if (msg.action == null || msg.action == undefined) return;
        /* ACTIONS */
        switch(msg.action) {
            case 'mugshot':
                dataURL(msg.url, function(mugshot){
                    $.post(`https://${GetParentResourceName()}/mugshot`, JSON.stringify({
                        url: mugshot,
                        handle: msg.handle
                    }));
                });
                break;
            case 'closeUI':
                resetUI();
                break;
            case 'openUI':
                openUI(msg.characters, msg.slots);
                break;
        }
    });

    let currentCharacterId = 0
    $(document).on('click', '.character-select-option', function(e) {
        e.preventDefault();
        if ($(this).hasClass('active') || isBusy) return;
        let id = $(this).data('id');
        if (id == undefined || id == null) return;
        isBusy = true;
        $('.character-select-option').removeClass('active');
        currentCharacterId = id;
        if (currentCharacterId <= 0) {
            $('#multiCharacter').fadeOut();
            $('.character-info').fadeOut();
            $('.character-buttons').fadeOut();
            $('#deleteModal').fadeOut();
            setTimeout(() => {
                $('#characterInfo').html('');
                $('.character-buttons').html('');
            }, 1000);
            $('#characterCreation')[0].reset();
            $('.character-creator-form-input').removeClass('error');
            $('.character-creator-form-notify').removeClass('danger', 'warning').text('').hide();
            changeSpawnCamera($('#spawnPoint').val());
            changeClassDescription($('#class').val());
            $('#identity').show();
        } else {
            var money = Intl.NumberFormat("en-US", {
                style: "currency",
                currency: "USD",
                minimumFractionDigits: 2,
            });
            var l = config.locale;
            var character = data.characters[currentCharacterId];
            if (character) {
                $(this).addClass('active');
                var acc = character.accounts
                var wallet = (acc.money ? acc.money : 0);
                var bank = (acc.bank ? acc.bank : 0)
                $('#characterInfo').html(`
                    <p class="character-info-name">${character.name}</p>
                    <p class="character-info-birthdate">${character.dateofbirth}</p>
                    <p class="character-info-subtitle">${l.ui_info_job} <span class="material-symbols-outlined">business_center</span></p>
                    <p class="character-info-text">${character.job}</p>
                    <p class="character-info-subtitle">${l.ui_info_money} <span class="material-symbols-outlined">account_balance_wallet</span></p>
                    <p class="character-info-text">${money.format(wallet)}</p>
                    <p class="character-info-subtitle">${l.ui_info_bank} <span class="material-symbols-outlined">account_balance</span></p>
                    <p class="character-info-text">${money.format(bank)}</p>
                `);
                $('.character-info').show();
                $('.character-buttons').fadeOut();
                setTimeout(function(){
                    $('.character-buttons').html('')
                    if (!character.disabled) {
                        $('.character-buttons').append(`
                            <button class="character-button" data-action="play"><span class="material-symbols-outlined">play_arrow</span></button>
                        `);
                    }
                    if (config.allow_character_remove) {
                        $('.character-buttons').append(`
                            <button class="character-button button-delete" data-action="delete"><span class="material-symbols-outlined">delete</span></button>
                        `);
                    }
                    $('.character-buttons').show();
                }, 1000)
            }
        }
        $.post(`https://${GetParentResourceName()}/selectCharacter`, JSON.stringify(currentCharacterId),
            function() {
                isBusy = false;
            }
        );
    });

    $(document).on('change', '#spawnPoint', function(e){
        changeSpawnCamera($(this).val());
    });

    $(document).on('change', '#class', function(e){
        changeClassDescription($(this).val());
    });

    $(document).on('click', '.character-creator-form-button', function(e) {
        e.preventDefault();
        let action = $(this).data('action');
        if (!action || isBusy) return;
        isBusy = true;
        if (action == 'reset') {
            $('#characterCreation')[0].reset();
            $('.character-creator-form-input').removeClass('error');
            changeSpawnCamera($('#spawnPoint').val());
            changeClassDescription($('#class').val());
            isBusy = false;
        } else if (action == 'cancel') {
            $('#identity').fadeOut();
            setTimeout(() => {
                $('#characterCreation')[0].reset();
                $('.character-creator-form-input').removeClass('error');
                $('.character-creator-form-notify').removeClass('danger', 'warning').text('').hide();
                isBusy = false;
            }, 1000);
            $('#multiCharacter').show();
        } else if (action == 'create') {
            $('.character-creator-form-notify').fadeOut();
            $('.character-creator-form-input').removeClass('error');
            setTimeout(function(){
                $('.character-creator-form-notify').text('');
                var birthDate = $('#birthDate').val();
                if (!birthDate) {
                    $(`#birthDate`).addClass('error');
                    $('.character-creator-form-notify').removeClass('danger', 'warning').addClass('danger').text(config.locale.invalid_date.replace('%s', config.validation_data.lowest_year).replace('%s', config.validation_data.highest_year)).fadeIn();
                    isBusy = false;
                    return;
                }
                const dateCheck = new Date(birthDate);
                const year = new Intl.DateTimeFormat("en", { year: "numeric" }).format(dateCheck);
                const month = new Intl.DateTimeFormat("en", { month: "2-digit" }).format(dateCheck);
                const day = new Intl.DateTimeFormat("en", { day: "2-digit" }).format(dateCheck);
                const formattedDate = `${month}/${day}/${year}`;

                $.post(`https://${GetParentResourceName()}/createCharacter`, JSON.stringify({
                    firstName: $('#firstName').val(),
                    lastName: $('#lastName').val(),
                    sex: $('#sex').val(),
                    height: $('#height').val(),
                    dateOfBirth: formattedDate,
                    nationality: $('#nationality').val(),
                    spawnPoint: $('#spawnPoint').val(),
                    class: $('#class').val(),
                }), function(response){
                    if (response.error) {
                        if (response.field) $(`#${response.field}`).addClass('error');
                        $('.character-creator-form-notify').removeClass('danger', 'warning').addClass('danger').text(response.message).fadeIn();
                    }
                    isBusy = false;
                });
            }, 1000);
        }
    });

    $(document).on('click', '.character-button', function(e) {
        e.preventDefault();
        let action = $(this).data('action');
        if (!action) return;
        if (action == 'play') {
            if (isBusy) return;
            isBusy = true;
            $.post(`https://${GetParentResourceName()}/playCharacter`, JSON.stringify(currentCharacterId),
                function() {
                    isBusy = false;
                }
            );
        } else if (action == 'delete') {
            $('#deleteModal').fadeIn(500);
        };
    });

    $(document).on('click', '.character-delete-button', function(e) {
        e.preventDefault();
        let action = $(this).data('action');
        if (!action) return;
        if (action == 'delete') {
            if (isBusy) return;
            isBusy = true;
            $.post(`https://${GetParentResourceName()}/deleteCharacter`, JSON.stringify(currentCharacterId),
                function() {
                    isBusy = false;
                }
            );
        } else if (action == 'cancel') {
            $('#deleteModal').fadeOut(500);
        };
    });

    $.post(`https://${GetParentResourceName()}/ready`, JSON.stringify({}),
        function(response) {
            buildUI(response);
        }
    );
}