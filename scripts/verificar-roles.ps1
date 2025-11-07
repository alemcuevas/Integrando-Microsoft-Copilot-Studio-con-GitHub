# verificar-roles.ps1
# Script para verificar los roles de seguridad del usuario actual

Write-Host "🔍 Verificando roles de seguridad..." -ForegroundColor Cyan

# Obtener información del usuario actual
Write-Host "`n📌 Usuario actual:" -ForegroundColor Yellow
pac auth list | Select-String "Universal"

# Verificar ambientes
Write-Host "`n🌍 Ambientes disponibles:" -ForegroundColor Yellow
pac admin list

Write-Host "`n" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "📋 PRÓXIMOS PASOS:" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n1. 🔗 Abre Power Platform Admin Center:" -ForegroundColor White
Write-Host "   https://admin.powerplatform.microsoft.com/environments" -ForegroundColor Gray

Write-Host "`n2. 🎯 Selecciona el ambiente: Contoso (default)" -ForegroundColor White

Write-Host "`n3. ⚙️  Ve a: Settings → Users + permissions → Security roles" -ForegroundColor White

Write-Host "`n4. 👤 Busca tu usuario: admin@MngEnvMCAP975128.onmicrosoft.com" -ForegroundColor White

Write-Host "`n5. ✅ Asigna el rol: System Administrator" -ForegroundColor White

Write-Host "`n6. 💾 Guarda los cambios" -ForegroundColor White

Write-Host "`n7. ⏳ Espera 5 minutos para que los permisos se propaguen" -ForegroundColor White

Write-Host "`n8. 🔄 Vuelve a autenticarte:" -ForegroundColor White
Write-Host "   pac auth clear" -ForegroundColor Gray
Write-Host "   pac auth create --environment e6a705ce-a278-4500-96ec-ae709758249d" -ForegroundColor Gray

Write-Host "`n" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "⚠️  SI NO TIENES ACCESO AL ADMIN CENTER:" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`nContacta al Administrador Global de tu tenant:" -ForegroundColor White
Write-Host "   • Solicita el rol 'System Administrator' en el ambiente 'Contoso'" -ForegroundColor Gray
Write-Host "   • O solicita el privilegio 'prvWriteOrganization' específicamente" -ForegroundColor Gray

Write-Host "`nMientras tanto, puedes usar el workflow manual:" -ForegroundColor White
Write-Host "   .\scripts\export-solution.ps1" -ForegroundColor Gray
Write-Host "   pac solution unpack --zipfile MyRetailAgent.zip --folder solution --allowWrite --allowDelete" -ForegroundColor Gray
Write-Host "   git add ." -ForegroundColor Gray
Write-Host "   git commit -m 'chore: actualizar solución'" -ForegroundColor Gray
Write-Host "   git push origin main" -ForegroundColor Gray

Write-Host "`n✨ Presiona cualquier tecla para continuar..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
