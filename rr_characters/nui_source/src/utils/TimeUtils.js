import { useConfig } from '@/stores/config';

export default class TimeUtils {

    formatSeconds(seconds) {
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

    timeToLastSeenString(time){

        var l = config.locale;

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
                    return `${l?.ui_last_seen_yesterday}`;
                } else return `${days} ${l?.ui_last_seen_days} ${l?.ui_last_seen_ago}`;
            } else if (hours > 0) {
                return `${hours}h ${l?.ui_last_seen_ago}`;
            } else if (minutes > 0) {
                return `${minutes}m ${l?.ui_last_seen_ago}`;
            } else if (seconds > 0) {
                return `${seconds}s ${l?.ui_last_seen_ago}`;
            } else return `${l?.ui_last_seen_never}`;
        } else return `${l?.ui_last_seen_never}`;
    }

}