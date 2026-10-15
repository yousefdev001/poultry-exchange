// ========================================================
// Elshams Poultry - Landing Page JavaScript (Live Firestore)
// ========================================================

const firebaseConfig = {
  apiKey: "AIzaSyDzyxXuDXRoa1VHQwxUov0HLHqxoE2sXh4",
  authDomain: "elshams-36c71.firebaseapp.com",
  projectId: "elshams-36c71",
  storageBucket: "elshams-36c71.firebasestorage.app",
  messagingSenderId: "1027887454990",
  appId: "1:1027887454990:web:e11f775ab90231fc77955f"
};

let db = null;
try {
  if (typeof firebase !== 'undefined') {
    firebase.initializeApp(firebaseConfig);
    db = firebase.firestore();
  }
} catch (e) {
  console.warn('Firebase init:', e);
}

const defaultPoultryProducts = [
  { name: 'فراخ كاملة', multiplier: 1.60, increase: 25 },
  { name: 'صدور بالعظم', multiplier: 1.55, increase: 25 },
  { name: 'ورك عادة', multiplier: 1.25, increase: 20 },
  { name: 'ورك مقصف', multiplier: 1.45, increase: 25 },
  { name: 'دبوس', multiplier: 1.30, increase: 20 },
  { name: 'شيش بالجلد', multiplier: 1.65, increase: 30 },
  { name: 'شيش كامل بدون جلد', multiplier: 1.80, increase: 30 },
  { name: 'فيليه (بانيه)', multiplier: 2.95, increase: 25 },
  { name: 'شاورما مسحب', multiplier: 2.10, increase: 25 },
  { name: 'صدور فيليه بالجلد', multiplier: 2.70, increase: 25 }
];

function calcProductPrice(livePrice, multiplier, increase) {
  return Math.ceil(livePrice * multiplier + increase);
}

function getArabicToday() {
  const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
  try {
    return new Intl.DateTimeFormat('ar-EG', options).format(new Date());
  } catch (_) {
    return new Date().toLocaleDateString('ar-EG');
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const dateElements = document.querySelectorAll('.live-date-text');
  const todayStr = getArabicToday();
  dateElements.forEach(el => el.textContent = todayStr);

  const menuToggle = document.getElementById('menuToggle');
  const navMenu = document.getElementById('navMenu');

  if (menuToggle && navMenu) {
    menuToggle.addEventListener('click', () => {
      navMenu.classList.toggle('active');
    });

    document.querySelectorAll('.nav-link').forEach(link => {
      link.addEventListener('click', () => {
        navMenu.classList.remove('active');
      });
    });
  }

  const tabBtns = document.querySelectorAll('.tab-btn');
  const tabContents = document.querySelectorAll('.tab-content');

  tabBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      tabBtns.forEach(b => b.classList.remove('active'));
      tabContents.forEach(c => c.classList.remove('active'));

      btn.classList.add('active');
      const tabId = btn.getAttribute('data-tab');
      const targetContent = document.getElementById(tabId);
      if (targetContent) targetContent.classList.add('active');
    });
  });

  const modal = document.getElementById('imageModal');
  const modalImg = document.getElementById('modalImage');
  const modalClose = document.getElementById('modalClose');

  document.querySelectorAll('.gallery-item').forEach(item => {
    item.addEventListener('click', () => {
      const img = item.querySelector('img');
      if (img && modal && modalImg) {
        modalImg.src = img.src;
        modal.classList.add('active');
      }
    });
  });

  if (modalClose && modal) {
    modalClose.addEventListener('click', () => modal.classList.remove('active'));
    modal.addEventListener('click', (e) => {
      if (e.target === modal) modal.classList.remove('active');
    });
  }

  loadAllPrices();
});

async function loadAllPrices() {
  let livePrice = 100;

  try {
    if (db) {
      // 1. Settings / Live Price
      const settingsSnap = await db.collection('settings').get();
      settingsSnap.forEach(doc => {
        const data = doc.data();
        if (data.livePrice) livePrice = data.livePrice;
      });

      updateLivePriceDisplays(livePrice);

      // 2. Products
      const prodSnap = await db.collection('products').where('isActive', '==', true).get();
      let products = [];
      prodSnap.forEach(doc => {
        const data = doc.data();
        products.push({
          id: doc.id,
          name: data.name || '',
          multiplier: data.multiplier || 1,
          increase: data.increase || 0
        });
      });

      if (products.length === 0) {
        products = defaultPoultryProducts;
      }
      renderPoultryProducts(products, livePrice);

      // 3. Poultry Market
      const marketSnap = await db.collection('poultry_market_prices').where('isActive', '==', true).get();
      let marketItems = [];
      marketSnap.forEach(doc => {
        const data = doc.data();
        marketItems.push({
          name: data.name,
          price: data.price
        });
      });
      renderMarketProducts(marketItems);

      // 4. Chicks
      const chicksSnap = await db.collection('chicks_prices').where('isActive', '==', true).get();
      let chicks = [];
      chicksSnap.forEach(doc => {
        const data = doc.data();
        chicks.push({
          name: data.name,
          price: data.price
        });
      });
      renderChicks(chicks);

      // 5. Eggs
      const eggsSnap = await db.collection('eggs_prices').where('isActive', '==', true).get();
      let eggs = [];
      eggsSnap.forEach(doc => {
        const data = doc.data();
        eggs.push({
          name: data.name,
          price: data.price
        });
      });
      renderEggs(eggs);

      return;
    }
  } catch (err) {
    console.warn('Live fetch notice:', err);
  }

  // Fallbacks
  updateLivePriceDisplays(livePrice);
  renderPoultryProducts(defaultPoultryProducts, livePrice);
  renderMarketProducts([
    { name: 'أمهات أبيض', price: 85 },
    { name: 'دجاج ساسو', price: 110 },
    { name: 'بط مسكوفي', price: 135 },
    { name: 'ديك رومي أبيض', price: 145 }
  ]);
  renderChicks([
    { name: 'كتكوت أبيض شركات', price: 38 },
    { name: 'كتكوت أبيض أهالي', price: 34 },
    { name: 'كتكوت ساسو بيور', price: 23 },
    { name: 'كتكوت بلدي مشعر', price: 14 }
  ]);
  renderEggs([
    { name: 'طبق بيض أحمر', price: 170 },
    { name: 'طبق بيض أبيض', price: 165 },
    { name: 'طبق بيض بلدي', price: 160 }
  ]);
}

function updateLivePriceDisplays(livePrice) {
  const heroLive = document.getElementById('heroLivePrice');
  const bannerLive = document.getElementById('bannerLivePrice');
  if (heroLive) heroLive.textContent = Math.ceil(livePrice);
  if (bannerLive) bannerLive.textContent = Math.ceil(livePrice);
}

function renderPoultryProducts(products, livePrice) {
  const container = document.getElementById('poultryGrid');
  if (!container) return;

  container.innerHTML = '';
  products.forEach(p => {
    const finalPrice = calcProductPrice(livePrice, p.multiplier, p.increase);
    const card = document.createElement('div');
    card.className = 'product-price-card';
    card.innerHTML = `
      <div class="card-info">
        <h4>${p.name}</h4>
        <span>فريش يومي - مغلف</span>
      </div>
      <div class="card-price-tag">
        <strong>${finalPrice}</strong>
        <small>جنيه / كجم</small>
      </div>
    `;
    container.appendChild(card);
  });
}

function renderMarketProducts(items) {
  const container = document.getElementById('marketGrid');
  if (!container) return;

  if (items.length === 0) {
    container.innerHTML = '<div style="grid-column: 1/-1; text-align: center; color: #9C8974; padding: 30px;">لا توجد أصناف معروضة حالياً</div>';
    return;
  }

  container.innerHTML = '';
  items.forEach(item => {
    const card = document.createElement('div');
    card.className = 'product-price-card';
    card.innerHTML = `
      <div class="card-info">
        <h4>🍗 ${item.name}</h4>
        <span>حي بالوزن</span>
      </div>
      <div class="card-price-tag">
        <strong>${Math.ceil(item.price)}</strong>
        <small>جنيه / كجم</small>
      </div>
    `;
    container.appendChild(card);
  });
}

function renderChicks(items) {
  const container = document.getElementById('chicksGrid');
  if (!container) return;

  if (items.length === 0) {
    container.innerHTML = '<div style="grid-column: 1/-1; text-align: center; color: #9C8974; padding: 30px;">لا توجد أسعار كتاكيت معروضة حالياً</div>';
    return;
  }

  container.innerHTML = '';
  items.forEach(item => {
    const card = document.createElement('div');
    card.className = 'product-price-card';
    card.innerHTML = `
      <div class="card-info">
        <h4>🐣 ${item.name}</h4>
        <span>عمر يوم - فرز أول ممتاز</span>
      </div>
      <div class="card-price-tag">
        <strong>${Math.ceil(item.price)}</strong>
        <small>جنيه / كتكوت</small>
      </div>
    `;
    container.appendChild(card);
  });
}

function renderEggs(items) {
  const container = document.getElementById('eggsGrid');
  if (!container) return;

  if (items.length === 0) {
    container.innerHTML = '<div style="grid-column: 1/-1; text-align: center; color: #9C8974; padding: 30px;">لا توجد أسعار بيض معروضة حالياً</div>';
    return;
  }

  container.innerHTML = '';
  items.forEach(item => {
    const card = document.createElement('div');
    card.className = 'product-price-card';
    card.innerHTML = `
      <div class="card-info">
        <h4>🥚 ${item.name}</h4>
        <span>كرتونة 30 بيضة</span>
      </div>
      <div class="card-price-tag">
        <strong>${Math.ceil(item.price)}</strong>
        <small>جنيه / كرتونة</small>
      </div>
    `;
    container.appendChild(card);
  });
}
