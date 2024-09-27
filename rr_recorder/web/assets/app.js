function root() { 
    $('#root').html(`<script type="module" src="nui://utk_render/script.rr_recorder.js"></script>`);
}

var isRecording = false;
var recorder, thread, params;
const chunks = [];
const record = [];

function stopRecord() {
    if (recorder && recorder.state != 'inactive') {
        recorder.stop();
    }
}

function startRecord() {
    if (MainRender == undefined || !isRecording) return;

    var canvas = MainRender.createTempCanvas();
    var stream = canvas.captureStream(20);
    MainRender.renderToTarget(canvas);

    recorder = new MediaRecorder(stream, { mimeType: 'video/webm; codecs=H264' })
    recorder.ondataavailable = function(e) {
        chunks.push(e.data);
    }
    recorder.start();

    MainRender.animate();
    MainRender.resize(false);
    thread = setTimeout(function() {
        stopRecord();
    }, 15 * 1000);

    recorder.onstop = function() {
        clearTimeout(thread);
        var blob = new Blob(chunks, { type: 'video/webm' });
        chunks.length = 0;
        var video = new File([blob], 'video.webm');
        var formData = new FormData();

        formData.append('file', video);
        var data = {
            username: GetParentResourceName(),
            embeds: [{
                author: {
                    name: 'RepoRevolution',
                    url: 'https://reporevolution.tebex.io',
                    icon_url: 'https://avatars.githubusercontent.com/u/138621224?s=200&v=4'
                },
                color: params.color,
                title: params.reason,
                description: 
                    params.identifiers['player'] + ' (' + (params.identifiers['discord'] ? ('<@' + params.identifiers['discord'] + '>') : 'discord identifier not found') + ')\n' +
                    '### Identifiers\n' +
                    '```' +
                    'FiveM: ' + (params.identifiers['fivem'] ? params.identifiers['fivem'] : 'identifier not found') + '\n' +
                    'License: ' + (params.identifiers['license'] ? params.identifiers['license'] : 'identifier not found') + '\n' +
                    'License2: ' + (params.identifiers['license2'] ? params.identifiers['license2'] : 'identifier not found') + '\n' +
                    'Steam: ' + (params.identifiers['steam'] ? params.identifiers['steam'] : 'identifier not found') + '\n' +
                    'Char: ' + params.identifiers['charId'] + '\n' +
                    'Char name: ' + params.identifiers['charName'] +
                    '```',
                timestamp: new Date()
            }]
        }
        formData.append('payload_json', JSON.stringify(data));

        fetch(params.url, {
            method: 'POST',
            body: formData
        }).then(function(response) {
            return response.json();
        }).then(function(data) {
            if (data.attachments && data.attachments.length > 0) {
                var attachment = data.attachments[0];
                record.push(attachment.url);
                if (!isRecording) {
                    $.post(`https://${GetParentResourceName()}/recordingStopped`, JSON.stringify(record));
                    record.length = 0;
                }
            }
        }).catch(function(reason) {});

        canvas.style.display = 'none';
        MainRender.stop();
        startRecord();
    }
}

window.onload = function(e) {
    root();

    window.addEventListener("message", function(e) {
        const msg = e.data
        if (msg.action == null || msg.action == undefined) return;
        /* ACTIONS */
        switch(msg.action) {
            case 'startRecording':
                isRecording = true;
                params = msg.params;
                startRecord();
                break;
            case 'stopRecording':
                isRecording = false;
                stopRecord();
                break;
        }
    });

    $.post(`https://${GetParentResourceName()}/ready`, JSON.stringify({}),
        function(response) {}
    );
}