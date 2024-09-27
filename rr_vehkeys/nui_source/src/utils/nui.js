export default {
    emulate(action, data = null) {
        window.dispatchEvent(
            new MessageEvent('message', {
                data: {
                    action,
                    data,
                }
            }),
        );
    },

    async send(event, data = {}) {
        return await fetch(`https://${GetParentResourceName()}/${event}`, {
            method: 'POST',
            headers: { 'Content-type': 'application/json' },
            body: JSON.stringify(data),
        });
    }
};