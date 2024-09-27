window.onload = function(e) {
    window.addEventListener("message", function(e) {
        const msg = e.data
        if (msg.action == null || msg.action == undefined) return;
        /* ACTIONS */
        switch(msg.action) {
            case 'sound':
                var sound = document.getElementById(msg.type);
                sound.load();
                sound.volume = 0.15;
                sound.play().catch((e) => {}); 
                break;
        }
    });
}