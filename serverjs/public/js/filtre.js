document.addEventListener('DOMContentLoaded', () => {
    const filterUser = document.getElementById('filter-user');
    const filterDoor = document.getElementById('filter-door');
    const resetFilters = document.getElementById('reset-filters');

    function applyFilters() {
        const userValue = filterUser.value.toLowerCase();
        const doorValue = filterDoor.value.toLowerCase();
        
        const rows = document.querySelectorAll('table tbody tr:not(.month-header)'); 
        const monthHeaders = document.querySelectorAll('table tbody tr.month-header'); 

        rows.forEach(row => {
            const user = row.getAttribute('data-user').toLowerCase();
            const door = row.getAttribute('data-door').toLowerCase();

            const matchesUser = !userValue || user.includes(userValue);
            const matchesDoor = !doorValue || door.includes(doorValue);

            row.style.display = matchesUser && matchesDoor ? '' : 'none';
        });

        monthHeaders.forEach(header => {
            let nextRow = header.nextElementSibling;
            let hasVisibleRows = false;

            while (nextRow && !nextRow.classList.contains('month-header')) {
                if (nextRow.style.display !== 'none') {
                    hasVisibleRows = true;
                    break;
                }
                nextRow = nextRow.nextElementSibling;
            }

            header.style.display = hasVisibleRows ? '' : 'none';
        });
    }

    filterUser.addEventListener('change', applyFilters);
    filterDoor.addEventListener('change', applyFilters);
    resetFilters.addEventListener('click', () => {
        filterUser.value = '';
        filterDoor.value = '';
        applyFilters();
    });
    applyFilters();
});
