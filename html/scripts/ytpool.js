let YT_POOL_MAX = 6;
const YT_POOL_KEEP = 1;
let ytIdCounter = 0;
const ytPlayers = [];

function ytDestroyPlayer(p) {
    if (p.checkReady) { clearInterval(p.checkReady); p.checkReady = null; }
    const frame = document.getElementById(p.div_id);
    if (frame) {
        if (frame.contentWindow && typeof frame.contentWindow.clearMe === "function") frame.contentWindow.clearMe();
        frame.src = "about:blank";
        setTimeout(function () {
            const f = document.getElementById(p.div_id);
            if (f) f.remove();
        }, 100);
    }
    const i = ytPlayers.indexOf(p);
    if (i >= 0) ytPlayers.splice(i, 1);
}

function ytMakeFrame(videoId, p) {
    const div_id = "ytp_" + (ytIdCounter++);
    p.div_id = div_id;
    const url = "https://cfx-nui-xsound/html/index2.html?url=" + sanitizeURL("https://www.youtube.com/watch?v=" + videoId + "&debug=" + debug);
    $("<iframe>", { id: div_id, src: url }).css({ width: "320px", height: "180px" }).appendTo("body");
    let attempts = 0;
    p.checkReady = setInterval(function () {
        attempts++;
        const frame = document.getElementById(div_id);
        if (frame && frame.contentWindow && frame.contentWindow.yPlayer) {
            clearInterval(p.checkReady); p.checkReady = null;
            p.yPlayer = frame.contentWindow.yPlayer;
            p.ready = true;
            p.yPlayer.addEventListener("onStateChange", function (e) {
                if (e.data == 0 && p.onEnded) p.onEnded();
            });
            if (p.onReady) p.onReady(p.yPlayer);
        } else if (attempts >= 50) {
            clearInterval(p.checkReady); p.checkReady = null;
            ytDestroyPlayer(p);
        }
    }, 100);
}

const YtPool = {
    acquire(videoId, onReady, onEnded) {
        for (const p of ytPlayers) {
            if (!p.busy && p.ready) {
                p.busy = true;
                p.onReady = onReady;
                p.onEnded = onEnded;
                try { p.yPlayer.loadVideoById(videoId); } catch (e) {}
                if (onReady) onReady(p.yPlayer);
                return p;
            }
        }
        if (ytPlayers.length >= YT_POOL_MAX) {
            let lru = null;
            for (const p of ytPlayers) {
                if (p.ready && (!lru || (p.bound || 0) < (lru.bound || 0))) lru = p;
            }
            if (lru) {
                lru.busy = true;
                lru.onReady = onReady;
                lru.onEnded = onEnded;
                lru.bound = ytIdCounter++;
                try { lru.yPlayer.loadVideoById(videoId); } catch (e) {}
                if (onReady) onReady(lru.yPlayer);
                return lru;
            }
        }
        const p = { div_id: null, ready: false, busy: true, yPlayer: null, onReady: onReady, onEnded: onEnded, checkReady: null, bound: ytIdCounter };
        ytPlayers.push(p);
        ytMakeFrame(videoId, p);
        return p;
    },

    release(p) {
        if (!p) return;
        p.busy = false;
        p.onReady = null;
        p.onEnded = null;
        if (p.ready && p.yPlayer) { try { p.yPlayer.stopVideo(); } catch (e) {} }
        let idle = 0;
        for (const q of ytPlayers) if (!q.busy) idle++;
        if (idle > YT_POOL_KEEP) ytDestroyPlayer(p);
    },
};
