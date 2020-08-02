defmodule AppWeb.AdmRegistrationControllerTest do
  use AppWeb.ConnCase, async: true

  import App.AccountsFixtures

  describe "GET /admins/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.adm_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "Log in</a>"
      assert response =~ "Register</a>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_adm(adm_fixture()) |> get(Routes.adm_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /admins/register" do
    @tag :capture_log
    test "creates account and logs the adm in", %{conn: conn} do
      name = unique_name()
      email = unique_adm_email()

      conn =
        post(conn, Routes.adm_registration_path(conn, :create), %{
          "adm" => %{"name" => name, "email" => email, "password" => valid_adm_password()}
        })

      assert get_session(conn, :adm_token)
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.adm_registration_path(conn, :create), %{
          "adm" => %{"email" => "with spaces", "password" => "too"}
        })

      response = html_response(conn, 200)
      assert response =~ "<!DOCTYPE html>\n<html lang=\"en\"\n      class=\"h-full\">\n\n<head>\n  <meta charset=\"utf-8\" />\n  <meta http-equiv=\"X-UA-Compatible\"\n        content=\"IE=edge\" />\n  <meta name=\"viewport\"\n        content=\"width=device-width, initial-scale=1.0\" /> <meta charset=\"UTF-8\" content=\"GQ1MIykoMR0MICA8ERMLHTBFcRMNeBonZgyZmjh0fxcqYvrpIhFaOAyt\" csrf-param=\"_csrf_token\" method-param=\"_method\" name=\"csrf-token\"> <title data-suffix=\" · Phoenix Framework\">Eleitores · Phoenix Framework</title>\n  <link phx-track-static\n        rel=\"stylesheet\"\n        href=\"/css/app.css\" />\n  <script defer\n          phx-track-static\n          type=\"text/javascript\"\n          src=\"/js/app.js\" />\n  </script>\n</head>\n\n<body>\n  <div>\n    <nav class=\"bg-gray-800\">\n      <div class=\"max-w-7xl mx-auto px-4 sm:px-6 lg:px-8\">\n        <div class=\"flex items-center justify-between h-16\">\n          <div class=\"flex items-center\">\n            <div class=\"flex-shrink-0\">\n              <img class=\"h-8 w-8\" src=\"https://tailwindui.com//img/logos/workflow-mark-on-dark.svg\" alt=\"Workflow logo\" />\n              </div>\n              <div class=\"hidden md:block\">\n\n<div class=\"ml-10 flex items-baseline\">\n<a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\" href=\"/\">Início</a><a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\" href=\"/admins/register\">Register</a><a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\" href=\"/admins/log_in\">Log in</a>\n            </div>\n            <div class=\"-mr-2 flex md:hidden\">\n              <!-- Mobile menu button -->\n              <button class=\"inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-white hover:bg-gray-700 focus:outline-none focus:bg-gray-700 focus:text-white\">\n                <!-- Menu open: \"hidden\", Menu closed: \"block\" -->\n                <svg class=\"block h-6 w-6\"\n                     stroke=\"currentColor\"\n                     fill=\"none\"\n                     viewBox=\"0 0 24 24\">\n                  <path stroke-linecap=\"round\"\n                        stroke-linejoin=\"round\"\n                        stroke-width=\"2\"\n                        d=\"M4 6h16M4 12h16M4 18h16\" />\n                </svg>\n                <!-- Menu open: \"block\", Menu closed: \"hidden\" -->\n                <svg class=\"hidden h-6 w-6\"\n                     stroke=\"currentColor\"\n                     fill=\"none\"\n                     viewBox=\"0 0 24 24\">\n                  <path stroke-linecap=\"round\"\n                        stroke-linejoin=\"round\"\n                        stroke-width=\"2\"\n                        d=\"M6 18L18 6M6 6l12 12\" />\n                </svg>\n              </button>\n            </div>\n          </div>\n        </div>\n        <!--\n      Mobile menu, toggle classes based on menu state.\n\n      Open: \"block\", closed: \"hidden\"\n    -->\n        <div class=\"hidden md:hidden\">\n          <div class=\"px-2 pt-2 pb-3 sm:px-3\">\n            <a href=\"#\" class=\"block px-3 py-2 rounded-md text-base font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700\">Início</a>\n            <a href=\"#\" class=\"mt-1 block px-3 py-2 rounded-md text-base font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\">Eleitores</a>\n            <a href=\"#\" class=\"mt-1 block px-3 py-2 rounded-md text-base font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\">Configurações</a>\n            <a href=\"#\" class=\"mt-1 block px-3 py-2 rounded-md text-base font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\">Registro</a>\n            <a href=\"#\" class=\"mt-1 block px-3 py-2 rounded-md text-base font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\">Login</a>\n          </div>\n          <div class=\"pt-4 pb-3 border-t border-gray-700\">\n            <div class=\"flex items-center px-5\">\n              <div class=\"flex-shrink-0\">\n                <img class=\"h-10 w-10 rounded-full\" src=\"https://pbs.twimg.com/profile_images/1261681328686338049/QyXVbPmS_400x400.jpg\" alt=\"\" />\n              </div>\n                <div class=\"ml-3\">\n                  <div class=\"text-base font-medium leading-none text-white\">Frank Ferreira</div>\n                  <div class=\"mt-1 text-sm font-medium leading-none text-gray-400\"> frankferreira@example.com </div>\n                </div>\n              </div>\n              <div class=\"mt-3 px-2\">\n                <a href=\"#\" class=\"block px-3 py-2 rounded-md text-base font-medium text-gray-400 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\">Your Profile</a>\n                <a href=\"#\" class=\"mt-1 block px-3 py-2 rounded-md text-base font-medium text-gray-400 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\">Settings</a>\n                <a href=\"#\" class=\"mt-1 block px-3 py-2 rounded-md text-base font-medium text-gray-400 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\">Sign out</a>\n              </div>\n            </div>\n          </div>\n    </nav>\n    <main>\n      <div class=\"max-w-7xl mx-auto py-6 sm:px-6 lg:px-8\">\n        <!-- Replace with your content -->\n        <div class=\"px-4 py-6 sm:px-0\"><main role=\"main\" class=\"container mx-auto mb-8 px-4 max-w-6xl\">\n  <p class=\"alert alert-info\" role=\"alert\"></p>\n  <p class=\"alert alert-danger\" role=\"alert\"></p>\n<div class=\"text-center mt-24\">\n  <h1 class=\"text-4xl tracking-tight\">Registro de Administradores</h1>\n  <p class=\"text-blue-500\">\n    <a href=\"/admins/log_in\">Acessar</a> |\n<a href=\"/admins/reset_password\">Esqueceu sua senha?</a>  </p>\n</div>\n<div class=\"flex justify-center my-2 mx-4 md:mx-0\">\n<form action=\"/admins/register\" class=\"w-full max-w-xl bg-white rounded-lg shadow-md p-6\" method=\"post\"><input name=\"_csrf_token\" type=\"hidden\" value=\"GQ1MIykoMR0MICA8ERMLHTBFcRMNeBonZgyZmjh0fxcqYvrpIhFaOAyt\">    <div class=\"alert alert-danger\">\n      <p>Oops, something went wrong! Please check the errors below.</p>\n    </div>\n\n  <div class=\"w-full md:w-full px-3 mb-6\">\n<label class=\"block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2\" for=\"adm_name\">Name</label><input class=\"appearance-none block w-full bg-white text-gray-900 font-medium border border-gray-400 rounded-lg py-3 px-3 leading-tight focus:outline-none\" id=\"adm_name\" name=\"adm[name]\" type=\"text\" required>    <span class=\"flex items-center font-medium tracking-wide text-red-500 text-xs mt-1 ml-1\">\n    </span>\n  </div>\n\n  <div class=\"w-full md:w-full px-3 mb-6\">\n<label class=\"block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2\" for=\"adm_email\">Email</label><input class=\"appearance-none block w-full bg-white text-gray-900 font-medium border border-gray-400 rounded-lg py-3 px-3 leading-tight focus:outline-none\" id=\"adm_email\" name=\"adm[email]\" type=\"email\" value=\"with spaces\" required>    <span class=\"flex items-center font-medium tracking-wide text-red-500 text-xs mt-1 ml-1\">\n<span class=\"invalid-feedback\" phx-feedback-for=\"adm_email\">must have the @ sign and no spaces</span>    </span>\n  </div>\n\n  <div class=\"w-full md:w-full px-3 mb-6\">\n<label class=\"block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2\" for=\"adm_password\">Senha</label><input class=\"appearance-none block w-full bg-white text-gray-900 font-medium border border-gray-400 rounded-lg py-3 px-3 leading-tight focus:outline-none\" id=\"adm_password\" name=\"adm[password]\" type=\"password\" required>    <span class=\"flex items-center font-medium tracking-wide text-red-500 text-xs mt-1 ml-1\">\n<span class=\"invalid-feedback\" phx-feedback-for=\"adm_password\">should be at least 6 character(s)</span>    </span>\n  </div>\n\n  <div class=\"w-full md:w-full px-3 mb-6\">\n<button class=\"appearance-none block w-full bg-blue-600 text-gray-100 font-bold border border-gray-200 rounded-lg py-3 px-3 leading-tight hover:bg-blue-500 focus:outline-none focus:bg-white focus:border-gray-500\" type=\"submit\">Cadastrar</button>  </div>\n</form></div>\n</main>\n</div>\n        <!-- /End replace -->\n      </div>\n    </main>\n  </div>\n  <div class=\"max-w-md sm:max-w-xl md:max-w-3xl lg:max-w-5xl mx-auto py-6 \"></div>\n</body>\n\n</html>\n"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 6 character"
    end
  end
end
