/**
 * MOTO-SHOP REAL-TIME CHAT ADD-ON
 * Nâng cấp từ Consultation sang Chat trực tiếp với Admin
 */
(function() {
    // 1. CSS Giao diện Chat
    const style = document.createElement('style');
    style.innerHTML = `
        .chat-float-btn {
            position: fixed; bottom: 30px; left: 30px; z-index: 99999;
            width: 60px; height: 60px; background: #E24B4A; color: white;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 30px; cursor: pointer; box-shadow: 0 4px 20px rgba(226, 75, 74, 0.4);
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        .chat-float-btn:hover { transform: scale(1.1) rotate(5deg); background: #c0392b; }
        
        #chatWindow {
            display: none; position: fixed; bottom: 100px; left: 30px; z-index: 99999;
            width: 350px; height: 500px; background: white; border-radius: 20px; overflow: hidden;
            box-shadow: 0 10px 40px rgba(0,0,0,0.15); border: 1px solid #f0f0f0;
            flex-direction: column;
        }
        #chatWindow.show { display: flex; animation: chatOpen 0.4s ease forwards; }
        @keyframes chatOpen { from { opacity: 0; transform: translateY(20px) scale(0.9); } to { opacity: 1; transform: translateY(0) scale(1); } }
        
        .chat-header { background: #E24B4A; color: white; padding: 18px; font-weight: 700; display: flex; justify-content: space-between; align-items: center; }
        .chat-messages { flex: 1; padding: 15px; overflow-y: auto; background: #f9f9f9; display: flex; flex-direction: column; gap: 10px; }
        
        .msg { max-width: 80%; padding: 10px 14px; border-radius: 15px; font-size: 14px; line-height: 1.4; position: relative; }
        .msg-user { align-self: flex-end; background: #E24B4A; color: white; border-bottom-right-radius: 2px; }
        .msg-admin { align-self: flex-start; background: #e0e0e0; color: #333; border-bottom-left-radius: 2px; }
        
        .chat-footer { padding: 15px; border-top: 1px solid #eee; display: flex; gap: 8px; background: #fff; }
        #chatInput { flex: 1; border: 1px solid #ddd; border-radius: 25px; padding: 10px 15px; outline: none; font-size: 14px; }
        #sendChat { background: #E24B4A; color: white; border: none; width: 40px; height: 40px; border-radius: 50%; cursor: pointer; display: flex; align-items: center; justify-content: center; }
    `;
    document.head.appendChild(style);

    // 2. HTML Cấu trúc Chat
    const chatContainer = document.createElement('div');
    chatContainer.innerHTML = `
        <div class="chat-float-btn" id="toggleChat">
            <i class='bx bxs-message-dots'></i>
        </div>
        <div id="chatWindow">
            <div class="chat-header">
                <div class="d-flex align-items-center gap-2">
                    <div style="width: 10px; height: 10px; background: #2ecc71; border-radius: 50%;"></div>
                    <span>Hỗ trợ MotoShop</span>
                </div>
                <i class='bx bx-x' style="cursor:pointer; font-size: 24px;" id="closeChat"></i>
            </div>
            <div class="chat-messages" id="chatMsgs">
                <div class="msg msg-admin">Chào bạn! MotoShop có thể giúp gì cho bạn?</div>
            </div>
            <div class="chat-footer">
                <input type="text" id="chatInput" placeholder="Nhập tin nhắn...">
                <button id="sendChat"><i class='bx bxs-send'></i></button>
            </div>
        </div>
    `;
    document.body.appendChild(chatContainer);

    // 3. Logic xử lý Chat
    const chatWin = document.getElementById('chatWindow');
    const chatMsgs = document.getElementById('chatMsgs');
    const chatInput = document.getElementById('chatInput');
    const sendBtn = document.getElementById('sendChat');

    document.getElementById('toggleChat').onclick = () => {
        chatWin.classList.toggle('show');
        if(chatWin.classList.contains('show')) {
            loadChatHistory();
            chatInput.focus();
        }
    };
    document.getElementById('closeChat').onclick = () => chatWin.classList.remove('show');

    async function loadChatHistory() {
        try {
            const res = await fetch('/Chat/GetMessages');
            const msgs = await res.json();
            if (msgs.length > 0) {
                chatMsgs.innerHTML = '';
                msgs.forEach(m => addMessageToUI(m.message, m.isFromAdmin));
                chatMsgs.scrollTop = chatMsgs.scrollHeight;
            }
        } catch (e) {}
    }

    function addMessageToUI(text, isAdmin) {
        const div = document.createElement('div');
        div.className = `msg ${isAdmin ? 'msg-admin' : 'msg-user'}`;
        div.innerText = text;
        chatMsgs.appendChild(div);
        chatMsgs.scrollTop = chatMsgs.scrollHeight;
    }

    async function sendMessage() {
        const msg = chatInput.value.trim();
        if (!msg) return;

        addMessageToUI(msg, false);
        chatInput.value = '';

        try {
            await fetch('/Chat/SendMessage', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: msg })
            });
        } catch (e) {
            console.error("Lỗi gửi tin nhắn");
        }
    }

    sendBtn.onclick = sendMessage;
    chatInput.onkeypress = (e) => { if(e.key === 'Enter') sendMessage(); };

    // Tự động kiểm tra tin nhắn mới mỗi 5 giây
    setInterval(() => {
        if (chatWin.classList.contains('show')) loadChatHistory();
    }, 5000);
})();
