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

        const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'nui-frame-app';
        const url = `http://${resourceName}/${event}`;

        console.log('SENDING TO NUI', url, data);

        return await fetch(url, {
            method: 'POST',
            headers: { 'Content-type': 'application/json' },
            body: JSON.stringify(data),
        }).then((response) => response.json());
    }
};