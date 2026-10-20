export const environment = {
  production: true,
  // Same-origin API. Nginx (gps-medical-assistance-edge) proxies /api to the .NET API.
  API_URL: '/api',
  API_MAP_SEARCH_LOCATION: 'https://nominatim.openstreetmap.org'
};
