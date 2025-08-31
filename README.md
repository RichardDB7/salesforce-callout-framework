# Salesforce Callout Framework

Framework modular en **Apex** para manejar integraciones HTTP (REST / SOAP) en Salesforce, diseñado para ser **metadata-driven**, extensible y fácil de testear.

## 🚀 Clases incluidas

- **IL_CalloutManager_cls** → Orquestador central de los callouts (ejecuta el request y procesa la respuesta).
- **IL_CalloutManagerHelper_cls** → Helper para construir endpoints completos, headers, timeouts y manejar configuración.
- **IL_CalloutParser** → Ejemplo de parser específico que implementa el contrato base.
- **IL_HttpRequest_cls** → Wrapper de `HttpRequest` con soporte de headers, encriptación y timeout.
- **IL_HttpResponse_cls** → Wrapper de `HttpResponse` estandarizado, con status code, body, errores y data parseada.
- **IL_MultiMockRequest_cls** → Utilidad para simular múltiples respuestas en test (testing de callouts).
- **IL_ParserFactory_cls** → Fábrica que instancia dinámicamente parsers según metadata (`Type.forName`).
- **IL_BaseParser_cls** → Contrato abstracto que define `parseRequest` y `parseResponse`.
- **IL_App_cls** → Excepciones custom (NotFoundException, WebServiceException, etc.).
- **IL_CalloutManager_tst** → Test class principal del framework.
- **IL_CalloutManagerMock_tst** → Test class que implementa `HttpCalloutMock`.

## 📂 Estructura del proyecto (SFDX)

force-app/
main/
default/
classes/
core & framework (CalloutManager, HttpRequest, HttpResponse, Helpers, Exceptions)
parsers (BaseParser, ParserFactory, parsers concretos)
tests (clases de test con mocks)

## 🧪 Testing

El framework incluye ejemplos de test con `HttpCalloutMock` para simular servicios externos sin hacer callouts reales.


