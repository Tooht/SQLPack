Describe "Get-DbaHealth" {
    It "Deve devolver um objeto com propriedades essenciais" {
        $result = Get-DbaHealth -Instance "localhost"

        $result.Instance | Should -Not -BeNullOrEmpty
        $result.Version  | Should -Not -BeNullOrEmpty
    }
}
