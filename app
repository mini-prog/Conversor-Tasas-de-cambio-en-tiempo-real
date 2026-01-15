<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <!-- Viewport ajustado para móviles: evita zoom y scroll horizontal -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    
    <title>Conversor Universal</title>

    <!-- Icono de la pestaña (Favicon) -->
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>💸</text></svg>">

    <!-- PWA / Ajustes de App Móvil -->
    <meta name="theme-color" content="#f8fafc">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="apple-mobile-web-app-title" content="Divisas">

    <!-- Tailwind CSS (Estilos) -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Fuente Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Iconos Lucide -->
    <script src="https://unpkg.com/lucide@latest"></script>
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
            overscroll-behavior-y: none; /* Evita rebote en móviles */
            -webkit-tap-highlight-color: transparent;
        }
        .fade-in {
            animation: fadeIn 0.3s ease-out forwards;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(5px); }
            to { opacity: 1; transform: translateY(0); }
        }
        /* Scroll personalizado y limpio */
        .custom-scroll::-webkit-scrollbar {
            width: 6px;
        }
        .custom-scroll::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        .custom-scroll::-webkit-scrollbar-thumb {
            background: #d1d5db;
            border-radius: 4px;
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4 bg-gradient-to-br from-slate-100 to-indigo-50">

    <!-- Contenedor Principal -->
    <div class="bg-white w-full max-w-md rounded-3xl shadow-xl overflow-hidden border border-white/50 relative z-10 flex flex-col max-h-[90vh]">
        
        <!-- Encabezado -->
        <div class="px-8 pt-8 pb-4 shrink-0">
            <h1 class="text-2xl font-bold text-slate-800">Conversor</h1>
            <p class="text-slate-400 text-sm">Tasas de cambio en tiempo real</p>
        </div>

        <!-- Área de Contenido con Scroll -->
        <div class="p-8 space-y-6 overflow-y-auto custom-scroll">

            <!-- Entrada de Cantidad -->
            <div class="bg-slate-50 p-4 rounded-2xl border border-slate-100 focus-within:ring-2 focus-within:ring-indigo-500 transition-all">
                <label class="block text-xs font-semibold text-slate-400 uppercase tracking-wider mb-1">Cantidad</label>
                <div class="flex items-center">
                    <span class="text-slate-400 text-xl font-light mr-2">$</span>
                    <input type="number" id="amount" value="100" min="0" inputmode="decimal" class="w-full bg-transparent border-none outline-none text-3xl font-bold text-slate-800 placeholder-slate-300" placeholder="0">
                </div>
            </div>

            <!-- Selectores de Moneda -->
            <div class="relative">
                <div class="grid grid-cols-[1fr,auto,1fr] gap-2 items-center">
                    
                    <!-- Botón Moneda Origen (De) -->
                    <button onclick="openSelector('from')" class="group flex flex-col items-start bg-slate-50 hover:bg-white hover:shadow-md border border-slate-100 hover:border-indigo-100 p-4 rounded-2xl transition-all duration-200 text-left w-full active:scale-95">
                        <span class="text-xs font-semibold text-slate-400 uppercase mb-1">De</span>
                        <div class="flex items-center gap-2">
                            <span id="fromFlag" class="text-2xl">🇺🇸</span>
                            <span id="fromCode" class="text-xl font-bold text-slate-700 group-hover:text-indigo-600 transition-colors">USD</span>
                        </div>
                        <span id="fromName" class="text-xs text-slate-400 mt-1 truncate w-full">Dólar EE.UU.</span>
                    </button>

                    <!-- Botón de Intercambio (Flechas) -->
                    <button id="swapBtn" class="p-3 rounded-full bg-white shadow-sm border border-slate-100 text-slate-400 hover:text-indigo-600 hover:shadow-md transition-all z-10 -mx-2 active:rotate-180">
                        <i data-lucide="arrow-right-left" class="w-5 h-5"></i>
                    </button>

                    <!-- Botón Moneda Destino (A) -->
                    <button onclick="openSelector('to')" class="group flex flex-col items-end bg-slate-50 hover:bg-white hover:shadow-md border border-slate-100 hover:border-indigo-100 p-4 rounded-2xl transition-all duration-200 text-right w-full active:scale-95">
                        <span class="text-xs font-semibold text-slate-400 uppercase mb-1">A</span>
                        <div class="flex items-center gap-2 flex-row-reverse">
                            <span id="toFlag" class="text-2xl">🇲🇽</span>
                            <span id="toCode" class="text-xl font-bold text-slate-700 group-hover:text-indigo-600 transition-colors">MXN</span>
                        </div>
                        <span id="toName" class="text-xs text-slate-400 mt-1 truncate w-full">Peso Mexicano</span>
                    </button>
                </div>
            </div>

            <!-- Caja de Resultado -->
            <div class="pt-2">
                <div class="flex flex-col items-center justify-center space-y-2">
                    <p id="rateText" class="text-sm text-slate-400 font-medium bg-slate-100 px-3 py-1 rounded-full">1 USD = ---</p>
                    <h2 id="resultText" class="text-5xl font-bold text-indigo-600 tracking-tight fade-in text-center break-all">---</h2>
                </div>
            </div>

            <!-- Botón para ver Tabla -->
            <div class="pt-4 border-t border-slate-100">
                <button onclick="toggleTable()" class="flex items-center justify-between w-full text-slate-500 hover:text-indigo-600 transition-colors py-2 group">
                    <span class="text-sm font-semibold flex items-center">
                        <i data-lucide="list" class="w-4 h-4 mr-2"></i>
                        Ver tabla de equivalencias
                    </span>
                    <i id="tableIcon" data-lucide="chevron-down" class="w-4 h-4 transition-transform duration-300"></i>
                </button>
                
                <div id="tableContainer" class="hidden overflow-hidden transition-all duration-300 mt-3">
                    <div class="bg-slate-50 rounded-xl overflow-hidden border border-slate-100">
                        <table class="min-w-full text-sm">
                            <tbody id="comparisonTableBody" class="divide-y divide-slate-100">
                                <!-- Las filas se generan con JS -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
        
        <!-- Pie de página (Estado) -->
        <div class="bg-slate-50 px-8 py-3 border-t border-slate-100 flex justify-between items-center shrink-0">
            <div class="flex items-center gap-2">
                <button onclick="manualUpdate()" id="refreshBtn" class="p-1.5 rounded-full hover:bg-slate-100 text-slate-400 hover:text-indigo-600 transition-all active:scale-90" title="Actualizar tasas">
                    <i data-lucide="refresh-cw" class="w-3.5 h-3.5"></i>
                </button>
                <span id="lastUpdate" class="text-[10px] text-slate-400 uppercase tracking-wide">Iniciando...</span>
            </div>
            <div id="statusDot" class="w-2 h-2 rounded-full bg-green-500 animate-pulse" title="Online"></div>
        </div>
    </div>

    <!-- VENTANA MODAL (Selector de País) -->
    <div id="currencyModal" class="fixed inset-0 bg-slate-900/20 backdrop-blur-sm z-50 hidden flex items-end sm:items-center justify-center opacity-0 transition-opacity duration-200">
        <div class="bg-white w-full max-w-md h-[80vh] sm:h-[600px] rounded-t-3xl sm:rounded-3xl shadow-2xl flex flex-col transform translate-y-full transition-transform duration-300" id="modalContent">
            
            <!-- Cabecera del Modal -->
            <div class="p-6 border-b border-slate-100 flex justify-between items-center shrink-0">
                <h3 class="text-lg font-bold text-slate-800">Seleccionar Moneda</h3>
                <button onclick="closeSelector()" class="p-2 hover:bg-slate-100 rounded-full text-slate-400 transition-colors">
                    <i data-lucide="x" class="w-5 h-5"></i>
                </button>
            </div>

            <!-- Barra de Búsqueda -->
            <div class="px-6 py-4 bg-slate-50/50 shrink-0">
                <div class="relative">
                    <i data-lucide="search" class="absolute left-4 top-1/2 transform -translate-y-1/2 w-4 h-4 text-slate-400"></i>
                    <input type="text" id="searchInput" placeholder="Buscar país o moneda..." class="w-full pl-10 pr-4 py-3 bg-white border border-slate-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-transparent outline-none text-slate-700 shadow-sm">
                </div>
            </div>

            <!-- Lista de Países -->
            <div class="flex-1 overflow-y-auto custom-scroll p-2" id="currencyList">
                <!-- Lista generada con JS -->
            </div>
        </div>
    </div>

    <script>
        // Inicializar Iconos
        lucide.createIcons();

        // Base de Datos de Monedas
        let currencies = [
            { code: 'USD', name: 'Dólar Estadounidense', flag: '🇺🇸', rate: 1.0 },
            { code: 'EUR', name: 'Euro', flag: '🇪🇺', rate: 0.92 },
            { code: 'MXN', name: 'Peso Mexicano', flag: '🇲🇽', rate: 17.10 },
            { code: 'COP', name: 'Peso Colombiano', flag: '🇨🇴', rate: 3915.0 },
            { code: 'ARS', name: 'Peso Argentino', flag: '🇦🇷', rate: 850.0 }, 
            { code: 'CLP', name: 'Peso Chileno', flag: '🇨🇱', rate: 945.0 },
            { code: 'PEN', name: 'Sol Peruano', flag: '🇵🇪', rate: 3.75 },
            { code: 'BRL', name: 'Real Brasileño', flag: '🇧🇷', rate: 4.95 },
            { code: 'GBP', name: 'Libra Esterlina', flag: '🇬🇧', rate: 0.79 },
            { code: 'JPY', name: 'Yen Japonés', flag: '🇯🇵', rate: 148.0 },
            { code: 'CAD', name: 'Dólar Canadiense', flag: '🇨🇦', rate: 1.35 },
            { code: 'AUD', name: 'Dólar Australiano', flag: '🇦🇺', rate: 1.52 },
            { code: 'CNY', name: 'Yuan Chino', flag: '🇨🇳', rate: 7.19 },
            { code: 'CHF', name: 'Franco Suizo', flag: '🇨🇭', rate: 0.88 },
            { code: 'UYU', name: 'Peso Uruguayo', flag: '🇺🇾', rate: 39.2 },
            { code: 'DOP', name: 'Peso Dominicano', flag: '🇩🇴', rate: 58.5 },
            { code: 'GTQ', name: 'Quetzal Guatemalteco', flag: '🇬🇹', rate: 7.8 },
            { code: 'CRC', name: 'Colón Costarricense', flag: '🇨🇷', rate: 515.0 },
            { code: 'VES', name: 'Bolívar Venezolano', flag: '🇻🇪', rate: 36.0 },
            { code: 'BOB', name: 'Boliviano', flag: '🇧🇴', rate: 6.91 },
            { code: 'PYG', name: 'Guaraní Paraguayo', flag: '🇵🇾', rate: 7280.0 }
        ];

        // Ordenar alfabéticamente
        currencies.sort((a, b) => a.name.localeCompare(b.name));

        // Estado Global
        let state = {
            amount: 100,
            from: 'USD',
            to: 'MXN',
            selecting: null // 'from' o 'to'
        };

        // Elementos del DOM
        const amountInput = document.getElementById('amount');
        const swapBtn = document.getElementById('swapBtn');
        const modal = document.getElementById('currencyModal');
        const modalContent = document.getElementById('modalContent');
        const currencyList = document.getElementById('currencyList');
        const searchInput = document.getElementById('searchInput');

        // Función de Inicio
        function init() {
            renderUI();
            fetchLiveRates();
            
            // Listeners (Eventos)
            amountInput.addEventListener('input', (e) => {
                state.amount = parseFloat(e.target.value);
                calculate();
            });
            
            swapBtn.addEventListener('click', swapCurrencies);
            
            searchInput.addEventListener('input', (e) => {
                renderCurrencyList(e.target.value);
            });

            // Cerrar modal al hacer clic fuera
            modal.addEventListener('click', (e) => {
                if (e.target === modal) closeSelector();
            });
        }

        // Trigger manual para el botón
        function manualUpdate() {
            // Animación visual de giro
            const btn = document.getElementById('refreshBtn');
            const icon = btn.querySelector('svg');
            
            if(icon) icon.classList.add('animate-spin');
            
            // Cambiar texto
            document.getElementById('lastUpdate').innerText = "Cargando...";

            fetchLiveRates().then(() => {
                // Detener giro tras un momento
                setTimeout(() => {
                    if(icon) icon.classList.remove('animate-spin');
                }, 800);
            });
        }

        // Obtener Tasas en Vivo (API Gratuita)
        async function fetchLiveRates() {
            try {
                const response = await fetch('https://api.exchangerate-api.com/v4/latest/USD');
                if (!response.ok) throw new Error('Error de red');
                const data = await response.json();
                
                // Actualizar tasas en nuestra base de datos local
                currencies.forEach(c => {
                    if (data.rates[c.code]) c.rate = data.rates[c.code];
                });

                const now = new Date();
                const timeString = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
                document.getElementById('lastUpdate').innerText = `Actualizado: ${timeString}`;
                document.getElementById('lastUpdate').classList.remove('text-red-400');
                document.getElementById('statusDot').className = "w-2 h-2 rounded-full bg-green-500 animate-pulse";
                
                calculate(); // Recalcular con datos nuevos
            } catch (error) {
                console.error("Error al obtener tasas", error);
                document.getElementById('lastUpdate').innerText = "Error (Modo Offline)";
                document.getElementById('lastUpdate').classList.add('text-red-400');
                document.getElementById('statusDot').className = "w-2 h-2 rounded-full bg-red-500";
            }
        }

        // --- Renderizado de Interfaz ---

        function renderUI() {
            // Actualizar Botón Origen
            const fromC = currencies.find(c => c.code === state.from);
            document.getElementById('fromFlag').innerText = fromC.flag;
            document.getElementById('fromCode').innerText = fromC.code;
            document.getElementById('fromName').innerText = fromC.name;

            // Actualizar Botón Destino
            const toC = currencies.find(c => c.code === state.to);
            document.getElementById('toFlag').innerText = toC.flag;
            document.getElementById('toCode').innerText = toC.code;
            document.getElementById('toName').innerText = toC.name;

            calculate();
        }

        function calculate() {
            if (isNaN(state.amount)) {
                document.getElementById('resultText').innerText = "---";
                return;
            }

            const fromC = currencies.find(c => c.code === state.from);
            const toC = currencies.find(c => c.code === state.to);

            // Fórmula: (Monto / TasaOrigen) * TasaDestino
            const result = (state.amount / fromC.rate) * toC.rate;
            const unitRate = (1 / fromC.rate) * toC.rate;

            document.getElementById('resultText').innerText = result.toLocaleString('es-MX', { 
                style: 'currency', currency: state.to, maximumFractionDigits: 2 
            });
            
            document.getElementById('rateText').innerText = `1 ${state.from} = ${unitRate.toFixed(4)} ${state.to}`;
            
            updateTable(fromC, toC, unitRate);
        }

        function swapCurrencies() {
            // Intercambiar variables
            const temp = state.from;
            state.from = state.to;
            state.to = temp;
            
            // Animar Icono
            const icon = swapBtn.querySelector('svg');
            icon.style.transition = 'transform 0.3s';
            icon.style.transform = 'rotate(180deg)';
            setTimeout(() => icon.style.transform = 'rotate(0deg)', 300);
            
            renderUI();
        }

        function updateTable(from, to, rate) {
            const amounts = [1, 10, 50, 100];
            const html = amounts.map(amt => `
                <tr class="hover:bg-slate-50 transition-colors">
                    <td class="px-6 py-3 font-medium text-slate-600">${amt.toLocaleString()} ${from.code}</td>
                    <td class="px-6 py-3 text-right font-bold text-indigo-600">${(amt * rate).toLocaleString(undefined, {maximumFractionDigits:2})} ${to.code}</td>
                </tr>
            `).join('');
            document.getElementById('comparisonTableBody').innerHTML = html;
        }

        function toggleTable() {
            const container = document.getElementById('tableContainer');
            const icon = document.getElementById('tableIcon');
            container.classList.toggle('hidden');
            
            // Rotar flecha
            icon.style.transform = container.classList.contains('hidden') ? 'rotate(0deg)' : 'rotate(180deg)';
        }

        // --- Lógica del Modal ---

        function openSelector(type) {
            state.selecting = type;
            modal.classList.remove('hidden');
            // Pequeño delay para permitir que la clase 'hidden' se quite antes de la transición
            setTimeout(() => {
                modal.classList.remove('opacity-0');
                modalContent.classList.remove('translate-y-full');
            }, 10);
            
            searchInput.value = "";
            searchInput.focus();
            renderCurrencyList("");
        }

        function closeSelector() {
            modal.classList.add('opacity-0');
            modalContent.classList.add('translate-y-full');
            
            // Esperar a que termine la animación para ocultar
            setTimeout(() => {
                modal.classList.add('hidden');
                state.selecting = null;
            }, 300);
        }

        function renderCurrencyList(filter) {
            const term = filter.toLowerCase();
            const filtered = currencies.filter(c => 
                c.name.toLowerCase().includes(term) || 
                c.code.toLowerCase().includes(term)
            );

            if (filtered.length === 0) {
                currencyList.innerHTML = `<div class="p-4 text-center text-slate-400 text-sm">No se encontraron monedas</div>`;
                return;
            }

            currencyList.innerHTML = filtered.map(c => {
                const isSelected = (state.selecting === 'from' && state.from === c.code) || 
                                   (state.selecting === 'to' && state.to === c.code);
                
                return `
                <button onclick="selectCurrency('${c.code}')" class="w-full flex items-center p-3 rounded-xl transition-all duration-200 ${isSelected ? 'bg-indigo-50 border border-indigo-100 ring-1 ring-indigo-200' : 'hover:bg-slate-50 border border-transparent'}">
                    <span class="text-3xl mr-4 drop-shadow-sm">${c.flag}</span>
                    <div class="text-left flex-1">
                        <div class="font-bold text-slate-800 flex items-center justify-between">
                            ${c.code}
                            ${isSelected ? '<i data-lucide="check" class="w-5 h-5 text-indigo-600"></i>' : ''}
                        </div>
                        <div class="text-xs text-slate-500 font-medium">${c.name}</div>
                    </div>
                </button>
            `}).join('');
            
            // Reinicializar iconos para los nuevos elementos
            lucide.createIcons();
        }

        function selectCurrency(code) {
            if (state.selecting === 'from') state.from = code;
            else state.to = code;
            
            closeSelector();
            renderUI();
        }

        // Iniciar App
        init();
    </script>
</body>
</html>
